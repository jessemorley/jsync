# JSYNC Backup

A macOS AppleScript application that automates rsync backups for Capture One photography sessions with real-time progress notifications.

## Features

- 🔄 **Automated Backups**: Syncs the active Capture One session folder using rsync
- 📊 **Progress Tracking**: Real-time notifications showing file counts, transfer speeds, and current files
- 💾 **Location Memory**: Remembers previously used backup destinations
- 🚨 **Error Handling**: Handles disk space issues and other backup errors gracefully
- 🎯 **Session Detection**: Automatically detects the current Capture One session folder

## Installation

### Download Release (Recommended)
1. Go to [Releases](https://github.com/jessemorley/jsync/releases)
2. Download the latest `JSYNC-Backup-vX.X.X.zip`
3. Unzip the archive
4. **Move `JSYNC Backup.scptd` to `~/Library/Scripts/Capture One Scripts/`**
5. The script will appear in Capture One's **Scripts** menu

**That's it!** No security warnings, no app permissions needed - it runs directly within Capture One.

### Build from Source
```bash
git clone https://github.com/jessemorley/jsync.git
cd jsync
./build.sh --bundle
```

## Usage

1. **Open Capture One** with a session loaded
2. **Go to Scripts menu** → **JSYNC Backup**
3. **Choose action:**
   - **Run Backup**: Use saved location or select new one
   - **Choose Location**: Browse for backup destination
   - **Cancel**: Exit without backing up
4. **Monitor progress** via system notifications
5. **Completion notification** shows transfer summary

## Development

This project uses a source-to-compiled workflow for AppleScript development:

### Project Structure
```
jsync/
├── src/
│   └── main.applescript          # Source code (edit this)
├── Contents/
│   ├── Info.plist               # App bundle metadata
│   └── Resources/Scripts/
│       └── main.scpt           # Compiled (auto-generated)
├── .github/workflows/
│   └── build-release.yml       # GitHub Actions
└── build.sh                    # Local build script
```

### Development Workflow

1. **Edit source code**: Work on `src/main.applescript`
2. **Build locally**: Run `./build.sh` to compile
3. **Test**: Run `./build.sh --app` to create test bundle
4. **Commit changes**: Git tracks source files only
5. **Create release**: Tag with `v1.x.x` to trigger auto-build

### Local Building
```bash
# Compile only
./build.sh

# Compile and create script bundle for testing
./build.sh --bundle
```

### Creating Releases

1. **Update version** in `src/main.applescript` header comment
2. **Commit changes**: `git commit -am "Update to v1.x.x"`
3. **Create tag**: `git tag v1.x.x`
4. **Push**: `git push && git push --tags`
5. **GitHub Actions** will automatically build and create release

## Technical Details

- **rsync flags**: `-av --delete --progress --stats`
- **Progress monitoring**: Parses rsync output every 3 seconds
- **Notifications**: macOS native notifications every 10 seconds
- **File estimation**: Pre-scans source directory for accurate progress
- **Error handling**: Disk space, permissions, and general rsync errors

## Requirements

- macOS 10.14 or later
- Capture One (any recent version)
- rsync (included with macOS)

## Backup Process

1. **Session Detection**: Communicates with Capture One to get active session path
2. **File Scanning**: Counts total files for progress calculation
3. **Background Sync**: Runs rsync with progress monitoring
4. **Progress Updates**: Shows notifications with current status
5. **Completion**: Final summary with transfer statistics

## Storage Locations

- **Backup preferences**: `~/Library/Application Support/CaptureOneBackup/`
- **Temp files**: Desktop (automatically cleaned up)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Edit `src/main.applescript`
4. Test with `./build.sh --app`
5. Submit a pull request

## License

Copyright © 2024 Jesse Morley. All rights reserved.

## Changelog

### v1.2.1
- Added real-time progress notifications
- Improved file count estimation
- Enhanced error handling
- Background rsync processing

### v1.2
- Initial GitHub release
- Basic backup functionality
- Capture One integration