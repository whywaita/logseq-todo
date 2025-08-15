import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    let onDismiss: (() -> Void)?
    
    @State private var selectedPath: String = ""
    @State private var selectedStatuses: Set<TaskStatus> = []
    @State private var selectedSortOrder: AppState.SortOrder = .newestFirst
    @State private var reloadIntervalMinutes: Double = 1
    
    init(onDismiss: (() -> Void)? = nil) {
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Settings")
                        .font(.title2)
                        .bold()
                    
                    GroupBox("Logseq Graph Folder") {
                        HStack {
                            TextField("Folder path", text: $selectedPath)
                                .textFieldStyle(.roundedBorder)
                                .disabled(true)
                            
                            Button("Select...") {
                                selectFolder()
                            }
                        }
                    }
                    
                    GroupBox("Display Statuses") {
                        VStack(alignment: .leading) {
                            ForEach(TaskStatus.allCases.filter { $0.isIncomplete }) { status in
                                Toggle(status.rawValue, isOn: Binding(
                                    get: { selectedStatuses.contains(status) },
                                    set: { isSelected in
                                        if isSelected {
                                            selectedStatuses.insert(status)
                                        } else {
                                            selectedStatuses.remove(status)
                                        }
                                    }
                                ))
                            }
                        }
                    }
                    
                    GroupBox("Sort Order") {
                        Picker("", selection: $selectedSortOrder) {
                            ForEach(AppState.SortOrder.allCases, id: \.self) { order in
                                Text(order.rawValue).tag(order)
                            }
                        }
                        .pickerStyle(.radioGroup)
                    }
                    
                    GroupBox("Auto-reload Interval") {
                        HStack {
                            Slider(value: $reloadIntervalMinutes, in: 0.5...10, step: 0.5)
                            Text("\(reloadIntervalMinutes, specifier: "%.1f") min")
                                .frame(width: 60)
                        }
                    }
                }
                .padding()
            }
            
            Divider()
            
            HStack {
                Button("Cancel") {
                    onDismiss?()
                }
                .keyboardShortcut(.cancelAction)
                
                Spacer()
                
                Button("Save") {
                    saveSettings()
                }
                .keyboardShortcut(.defaultAction)
                .buttonStyle(.borderedProminent)
                .disabled(selectedPath.isEmpty || selectedStatuses.isEmpty)
            }
            .padding()
        }
        .frame(width: 450, height: 500)
        .onAppear {
            loadCurrentSettings()
        }
    }
    
    private func loadCurrentSettings() {
        selectedPath = appState.graphPath
        selectedStatuses = appState.selectedStatuses
        selectedSortOrder = appState.sortOrder
        reloadIntervalMinutes = appState.reloadInterval / 60
    }
    
    private func selectFolder() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.message = "Select your Logseq graph folder"
        
        if panel.runModal() == .OK {
            selectedPath = panel.url?.path ?? ""
        }
    }
    
    private func saveSettings() {
        appState.graphPath = selectedPath
        appState.selectedStatuses = selectedStatuses
        appState.sortOrder = selectedSortOrder
        appState.reloadInterval = reloadIntervalMinutes * 60
        appState.saveSettings()
        appState.reload()
        onDismiss?()
    }
}