import Foundation

class LogseqParser {
    private let graphPath: String
    private let fileManager = FileManager.default
    
    init(graphPath: String) {
        self.graphPath = graphPath
    }
    
    func parseTasks() throws -> [LogseqTask] {
        var tasks: [LogseqTask] = []
        
        let pagesPath = URL(fileURLWithPath: graphPath).appendingPathComponent("pages")
        let journalsPath = URL(fileURLWithPath: graphPath).appendingPathComponent("journals")
        
        if fileManager.fileExists(atPath: pagesPath.path) {
            let pageTasks = try parseDirectory(pagesPath, isJournal: false)
            tasks.append(contentsOf: pageTasks)
        }
        
        if fileManager.fileExists(atPath: journalsPath.path) {
            let journalTasks = try parseDirectory(journalsPath, isJournal: true)
            tasks.append(contentsOf: journalTasks)
        }
        
        return tasks
    }
    
    private func parseDirectory(_ directory: URL, isJournal: Bool) throws -> [LogseqTask] {
        var tasks: [LogseqTask] = []
        
        let files = try fileManager.contentsOfDirectory(at: directory, 
                                                       includingPropertiesForKeys: [.contentModificationDateKey],
                                                       options: [.skipsHiddenFiles])
        
        for file in files where file.pathExtension == "md" {
            let fileTasks = try parseFile(file, isJournal: isJournal)
            tasks.append(contentsOf: fileTasks)
        }
        
        return tasks
    }
    
    private func parseFile(_ file: URL, isJournal: Bool) throws -> [LogseqTask] {
        var tasks: [LogseqTask] = []
        let content = try String(contentsOf: file, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines)
        
        let pageName = extractPageName(from: file, isJournal: isJournal)
        let fileAttributes = try fileManager.attributesOfItem(atPath: file.path)
        let fileMTime = fileAttributes[.modificationDate] as? Date
        
        var blockMetadata: [String: Any] = [:]
        var currentBlockId: String?
        
        for (index, line) in lines.enumerated() {
            if let (status, title) = extractTask(from: line) {
                let createdAt = extractCreatedAt(from: blockMetadata) ?? fileMTime
                
                let taskId = currentBlockId ?? "\(file.path):\(index + 1)"
                
                let task = LogseqTask(
                    id: taskId,
                    title: title,
                    status: status,
                    createdAt: createdAt,
                    filePath: file.path,
                    pageName: pageName,
                    lineNumber: index + 1
                )
                
                tasks.append(task)
            }
            
            if let id = extractBlockId(from: line) {
                currentBlockId = id
            }
            
            if let metadata = extractMetadata(from: line) {
                blockMetadata.merge(metadata) { _, new in new }
            }
            
            if line.trimmingCharacters(in: .whitespaces).isEmpty {
                blockMetadata.removeAll()
                currentBlockId = nil
            }
        }
        
        return tasks
    }
    
    private func extractTask(from line: String) -> (TaskStatus, String)? {
        // Pattern 1: Regular TODO format (- TODO task or TODO task)
        let pattern1 = #"^[\s-]*(TODO|DOING|NOW|LATER|DONE|CANCELLED|WAITING)\s+(.+)$"#
        
        // Pattern 2: Bracket format ([[TODO]] task)
        let pattern2 = #"^[\s-]*\[\[(TODO|DOING|NOW|LATER|DONE|CANCELLED|WAITING)\]\]\s+(.+)$"#
        
        // Try pattern 1
        if let regex1 = try? NSRegularExpression(pattern: pattern1, options: []) {
            let range = NSRange(location: 0, length: line.utf16.count)
            if let match = regex1.firstMatch(in: line, options: [], range: range) {
                if let statusRange = Range(match.range(at: 1), in: line),
                   let titleRange = Range(match.range(at: 2), in: line) {
                    let statusText = String(line[statusRange])
                    let title = String(line[titleRange]).trimmingCharacters(in: .whitespaces)
                    
                    if let status = TaskStatus(rawValue: statusText) {
                        return (status, title)
                    }
                }
            }
        }
        
        // Try pattern 2
        if let regex2 = try? NSRegularExpression(pattern: pattern2, options: []) {
            let range = NSRange(location: 0, length: line.utf16.count)
            if let match = regex2.firstMatch(in: line, options: [], range: range) {
                if let statusRange = Range(match.range(at: 1), in: line),
                   let titleRange = Range(match.range(at: 2), in: line) {
                    let statusText = String(line[statusRange])
                    let title = String(line[titleRange]).trimmingCharacters(in: .whitespaces)
                    
                    if let status = TaskStatus(rawValue: statusText) {
                        return (status, title)
                    }
                }
            }
        }
        
        return nil
    }
    
    private func extractBlockId(from line: String) -> String? {
        let pattern = #"id::\s*([a-zA-Z0-9-]+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        let range = NSRange(location: 0, length: line.utf16.count)
        guard let match = regex.firstMatch(in: line, options: [], range: range),
              let idRange = Range(match.range(at: 1), in: line) else {
            return nil
        }
        
        return String(line[idRange])
    }
    
    private func extractMetadata(from line: String) -> [String: Any]? {
        var metadata: [String: Any] = [:]
        
        let createdAtPattern = #"created-at::\s*(\d+)"#
        if let regex = try? NSRegularExpression(pattern: createdAtPattern, options: []) {
            let range = NSRange(location: 0, length: line.utf16.count)
            if let match = regex.firstMatch(in: line, options: [], range: range),
               let timestampRange = Range(match.range(at: 1), in: line) {
                if let timestamp = Double(line[timestampRange]) {
                    metadata["created-at"] = Date(timeIntervalSince1970: timestamp / 1000)
                }
            }
        }
        
        return metadata.isEmpty ? nil : metadata
    }
    
    private func extractCreatedAt(from metadata: [String: Any]) -> Date? {
        return metadata["created-at"] as? Date
    }
    
    private func extractPageName(from file: URL, isJournal: Bool) -> String {
        let fileName = file.deletingPathExtension().lastPathComponent
        
        if isJournal {
            return formatJournalDate(fileName)
        } else {
            return fileName.replacingOccurrences(of: "_", with: " ")
        }
    }
    
    private func formatJournalDate(_ fileName: String) -> String {
        let components = fileName.components(separatedBy: "_")
        if components.count == 3,
           let year = Int(components[0]),
           let month = Int(components[1]),
           let day = Int(components[2]) {
            return "\(year)/\(month)/\(day)"
        }
        return fileName
    }
}