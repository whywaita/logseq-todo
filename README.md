# Logseq TODO

<p align="center">
  <img src="assets/logo/readme_outline3_wood_500.png" alt="Logseq TODO Logo" width="200">
</p>

<p align="center">
  A macOS menu bar app for viewing Logseq TODO tasks
</p>

![Swift](https://img.shields.io/badge/Swift-6.0-orange)
![macOS](https://img.shields.io/badge/macOS-15%2B-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## Overview

Logseq TODO is a macOS menu bar application that provides quick access to your [Logseq](https://logseq.com/) TODO tasks. View your incomplete tasks without opening Logseq, streamlining your workflow and improving productivity.

### Key Features

- 🔍 **Read-only** - Safely displays tasks without modifying Logseq data
- 📝 **Multiple task formats** - Supports `TODO`, `[[TODO]]`, `- TODO` and other common formats
- 🔄 **Auto-reload** - Automatically refreshes tasks at configurable intervals (default: 60 seconds)
- 🎨 **Visual status indicators** - Colorful badges for TODO, DOING, NOW, LATER, etc.
- ⚡ **Lightweight** - Under 150MB memory usage with minimal CPU impact

## Motivation

While Logseq is a powerful knowledge management tool, opening the full application just to check TODO tasks can be cumbersome. This app addresses the following challenges:

1. **Improved accessibility** - One-click task access from the menu bar
2. **Maintained focus** - No need to open Logseq's full interface during work
3. **Never miss tasks** - Always displays the latest tasks to prevent oversight

## System Requirements

- **OS**: macOS 15 (Sequoia) or later
- **Architecture**: Apple Silicon (M1/M2/M3) Mac only
- **Dependencies**: None (standalone app)

## Installation

### Method 1: Homebrew Cask (Recommended)

```bash
# Add tap
brew tap whywaita/tap

# Install
brew install --cask logseq-todo
```

### Method 2: Manual Installation

1. Download the latest `LogseqTodo-x.x.x.zip` from the [Releases](https://github.com/whywaita/logseq-todo/releases) page
2. Double-click the ZIP file to extract
3. Drag `LogseqTodo.app` to your `Applications` folder
4. For first launch, right-click and select "Open"

## Usage

### Initial Setup

1. **Launch the app** - A checklist icon appears in the menu bar
2. **Right-click and select "Settings"**
3. **Select your Logseq graph folder** - Choose the parent directory containing `pages/` and `journals/` folders
4. **Choose task statuses to display** - Default: TODO and DOING
5. **Click Save**

### Basic Operations

- **Left-click**: Show/hide task list popover
- **Right-click**: Display menu
  - `Open Logseq TODO` - Open the popover
  - `Reload` (⌘R) - Manually refresh tasks
  - `Settings...` (⌘,) - Open settings window
  - `Quit` (⌘Q) - Exit the application

### Settings

| Setting | Description | Default |
|---------|-------------|---------|
| Graph Folder | Logseq graph root directory | None |
| Display Statuses | Task statuses to show (multi-select) | TODO, DOING |
| Sort Order | Task ordering | Newest First |
| Auto-reload Interval | Automatic refresh interval | 60 seconds |

## Building from Source

For developers:

### Prerequisites

- Xcode 16.0 or later
- Swift 6.0 or later
- macOS 15.0 or later

### Build Instructions

```bash
# Clone repository
git clone https://github.com/whywaita/logseq-todo.git
cd logseq-todo

# Build
make build

# Create app bundle
make app

# Create release ZIP archive
make release

# Clean up
make clean
```

## Troubleshooting

### Tasks Not Displaying

1. **Check graph folder**: Verify the correct Logseq graph folder is selected
2. **Check statuses**: Ensure desired statuses are selected in settings
3. **File format**: Only Markdown (.md) files are supported; org-mode is not supported

### App Won't Launch

- **macOS version**: Requires macOS 15 (Sequoia) or later
- **Architecture**: Apple Silicon Mac only (Intel Macs not supported)
- **Security settings**: For first launch, right-click → "Open"

### Text Appears Garbled

- **Encoding**: Ensure Markdown files are saved as UTF-8

## Privacy & Security

- **Read-only**: Never modifies Logseq data
- **Local operation**: No network communication
- **App Sandbox**: Runs within macOS sandbox
- **Minimal permissions**: Only accesses selected folder

## Contributing

Bug reports and feature requests are welcome via [Issues](https://github.com/whywaita/logseq-todo/issues).

Pull requests are also welcome:

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push the branch (`git push origin feature/amazing-feature`)
5. Create a Pull Request

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Author

- [@whywaita](https://github.com/whywaita)

## Acknowledgments

- [Logseq](https://logseq.com/) - Thanks to the team for creating an excellent knowledge management tool