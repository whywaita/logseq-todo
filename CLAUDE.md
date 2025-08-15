# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
A macOS menu bar application that displays TODO tasks from Logseq journals. Built with SwiftUI for macOS 15+ on Apple Silicon.

## Essential Commands

### Building & Running
```bash
# Build the app bundle
make app

# Clean and rebuild
make clean && make app

# Build only (without app bundle)
make build

# Create release artifacts
make release  # Creates ZIP + SHA256 hash
make dmg      # Creates DMG installer
```

### Testing
```bash
make test
# Note: Test files not yet implemented
```

### Development Workflow
1. Edit Swift files in `Sources/LogseqTodo/`
2. Run `make app` to build
3. Test the app from `build/LogseqTodo.app`
4. App logs can be viewed via Console.app

## High-Level Architecture

### Application Flow
1. **LogseqTodoApp.swift** creates NSStatusItem in menu bar
2. **AppState.swift** manages global state and triggers periodic reloads
3. **LogseqParser.swift** reads Logseq journal files from configured directory
4. **ContentView.swift** displays tasks in popover when menu bar icon clicked
5. Settings persisted to UserDefaults, accessible via right-click menu

### Key Design Decisions
- **Read-only access**: Parser never modifies Logseq files
- **Swift 6 concurrency**: Uses @MainActor for UI, Task.detached for file I/O
- **Fixed popover height** (500pt): Prevents layout issues with dynamic content
- **Menu bar only app**: LSUIElement=true in Info.plist (no Dock icon)

### Core Components

#### 1. Menu Bar Integration (`LogseqTodoApp.swift`)
- Uses `NSStatusItem` for menu bar presence
- Custom icon support via `Assets.xcassets/MenuBarIcon.imageset`
- Right-click context menu with options:
  - Open Logseq TODO
  - Reload
  - Settings
  - About
  - Quit

#### 2. Task Parser (`LogseqParser.swift`)
- Supports multiple TODO formats:
  - Standard: `TODO task description`
  - Hyphen prefix: `- TODO task description`
  - Bracket format: `[[TODO]] task description`
- Parses journal dates from filenames (YYYY_MM_DD.md format)
- Status types: TODO, DOING, NOW, LATER, DONE, CANCELLED, WAITING

#### 3. State Management (`AppState.swift`)
- Centralized app state using `ObservableObject`
- Auto-reload functionality (default: 60 seconds)
- Settings persistence via UserDefaults
- Sort options: Newest First, Oldest First

#### 4. UI Components
- **ContentView**: Main task list display
- **TaskListView**: Individual task cards with status badges
- **SettingsView**: Configuration for graph path, statuses, sort order
- **EmptyStateView**: Shown when no tasks or graph not configured

### Build Configuration

#### Package.swift
```swift
// swift-tools-version: 6.0
platforms: [.macOS(.v15)]
```

#### Info.plist Key Settings
- `LSUIElement`: true (menu bar only app)
- `CFBundleIconFile`: AppIcon
- Bundle ID: com.whywaita.logseq-todo

### Assets Structure
```
Assets.xcassets/
├── AppIcon.appiconset/    # App icon for Finder/Dock
├── MenuBarIcon.imageset/  # Menu bar icon
└── Contents.json
```

### Important Files & Locations

#### Configuration
- **Info.plist**: Bundle configuration (LSUIElement, icon settings)
- **Assets.xcassets/**: App icons and menu bar icons
- **UserDefaults keys**: `logseqGraphPath`, `sortOrder`, `enabledStatuses`, `autoReloadInterval`

#### Task Parsing Details
The parser (`LogseqParser.swift`) supports three TODO formats:
1. Standard: `TODO task description`
2. Hyphen prefix: `- TODO task description`  
3. Bracket format: `[[TODO]] task description`

Journal files must follow format: `YYYY_MM_DD.md` in `journals/` directory.

### Known Limitations
- macOS 15+ and Apple Silicon only (no Intel support)
- No task modification capability (read-only by design)
- Fixed 500pt popover height
- No keyboard shortcuts for menu bar actions