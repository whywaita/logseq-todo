import Foundation

struct LogseqTask: Identifiable, Hashable {
    let id: String
    let title: String
    let status: TaskStatus
    let createdAt: Date?
    let filePath: String
    let pageName: String
    let lineNumber: Int
    
    var displayDate: Date {
        createdAt ?? Date()
    }
}

enum TaskStatus: String, CaseIterable, Identifiable {
    case todo = "TODO"
    case doing = "DOING"
    case now = "NOW"
    case later = "LATER"
    case done = "DONE"
    case cancelled = "CANCELLED"
    case waiting = "WAITING"
    
    var id: String { rawValue }
    
    var isIncomplete: Bool {
        switch self {
        case .done, .cancelled:
            return false
        default:
            return true
        }
    }
}