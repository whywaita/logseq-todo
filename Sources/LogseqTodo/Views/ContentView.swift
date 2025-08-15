import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            if appState.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = appState.errorMessage {
                ErrorView(message: error)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if appState.tasks.isEmpty {
                EmptyStateView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                TaskListView()
            }
        }
        .frame(width: 400, height: 500)
    }
}

struct TaskListView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                ForEach(appState.tasks) { task in
                    TaskRowView(task: task)
                }
            }
            .padding()
        }
    }
}

struct TaskRowView: View {
    let task: LogseqTask
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                StatusBadge(status: task.status)
                Text(task.title)
                    .lineLimit(2)
                    .font(.system(size: 13))
                Spacer()
            }
            
            HStack {
                Text(task.pageName)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let date = task.createdAt {
                    Text(formatDate(date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(6)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
}

struct StatusBadge: View {
    let status: TaskStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(4)
    }
    
    var backgroundColor: Color {
        switch status {
        case .todo:
            return .blue
        case .doing, .now:
            return .orange
        case .later:
            return .purple
        case .waiting:
            return .yellow
        case .done:
            return .green
        case .cancelled:
            return .gray
        }
    }
}

struct EmptyStateView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checklist")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text(appState.graphPath.isEmpty ? "No graph folder selected" : "No tasks found")
                .font(.headline)
            
            if appState.graphPath.isEmpty {
                Button("Open Settings") {
                    
                }
            }
        }
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            Text(message)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}