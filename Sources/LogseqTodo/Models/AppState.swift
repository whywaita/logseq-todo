import Foundation
import SwiftUI

@MainActor
class AppState: ObservableObject {
    @Published var tasks: [LogseqTask] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedStatuses: Set<TaskStatus> = [.todo, .doing]
    @Published var sortOrder: SortOrder = .newestFirst
    @Published var graphPath: String = ""
    @Published var reloadInterval: TimeInterval = 60
    
    private var parser: LogseqParser?
    private var reloadTimer: Timer?
    
    init() {
        loadSettings()
        if !graphPath.isEmpty {
            reload()
        }
        startAutoReload()
    }
    
    enum SortOrder: String, CaseIterable {
        case newestFirst = "Newest First"
        case oldestFirst = "Oldest First"
    }
    
    func loadSettings() {
        if let data = UserDefaults.standard.data(forKey: "appSettings"),
           let settings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            self.graphPath = settings.graphPath
            self.selectedStatuses = Set(settings.selectedStatuses.compactMap { TaskStatus(rawValue: $0) })
            self.sortOrder = SortOrder(rawValue: settings.sortOrder) ?? .newestFirst
            self.reloadInterval = settings.reloadInterval
        }
    }
    
    func saveSettings() {
        let settings = AppSettings(
            graphPath: graphPath,
            selectedStatuses: Array(selectedStatuses).map { $0.rawValue },
            sortOrder: sortOrder.rawValue,
            reloadInterval: reloadInterval
        )
        
        if let data = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(data, forKey: "appSettings")
        }
        
        restartAutoReload()
    }
    
    func reload() {
        guard !graphPath.isEmpty else {
            errorMessage = "No Logseq graph folder selected"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let graphPathCopy = graphPath
        let selectedStatusesCopy = selectedStatuses
        let sortOrderCopy = sortOrder
        
        Task {
            do {
                let parser = LogseqParser(graphPath: graphPathCopy)
                let allTasks = try await Task.detached {
                    try parser.parseTasks()
                }.value
                
                let filteredTasks = allTasks.filter { task in
                    selectedStatusesCopy.contains(task.status) && task.status.isIncomplete
                }
                
                let sortedTasks = sortTasks(filteredTasks, order: sortOrderCopy)
                
                await MainActor.run {
                    self.tasks = sortedTasks
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    private func sortTasks(_ tasks: [LogseqTask], order: SortOrder) -> [LogseqTask] {
        switch order {
        case .newestFirst:
            return tasks.sorted { $0.displayDate > $1.displayDate }
        case .oldestFirst:
            return tasks.sorted { $0.displayDate < $1.displayDate }
        }
    }
    
    private func startAutoReload() {
        reloadTimer = Timer.scheduledTimer(withTimeInterval: reloadInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.reload()
            }
        }
    }
    
    private func restartAutoReload() {
        reloadTimer?.invalidate()
        startAutoReload()
    }
    
    func stopAutoReload() {
        reloadTimer?.invalidate()
        reloadTimer = nil
    }
}

struct AppSettings: Codable {
    let graphPath: String
    let selectedStatuses: [String]
    let sortOrder: String
    let reloadInterval: TimeInterval
}