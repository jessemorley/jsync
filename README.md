# JSYNC Backup

A macOS AppleScript application that automates rsync backups for Capture One sessions with real-time progress notifications.

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

## Usage

1. **Open Capture One** with a session loaded
2. **Go to Scripts menu** → **JSYNC Backup**
3. **Choose action:**
   - **Run Backup**: Use saved location or select new one
   - **Choose Location**: Browse for backup destination
   - **Cancel**: Exit without backing up
4. **Monitor progress** via system notifications
5. **Completion notification** shows transfer summary

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

### v1.3
- Improved backup completion notifications with cleaner formatting
- Added "Backing up changes..." notification when changes are detected
- Changed completion notification title to "Backup Complete"
- Moved temporary log files from desktop to system temp directory
- Enhanced notification flow for better user experience

### v1.2.2
- Cleaned up notification content

### v1.2.1
- Added real-time progress notifications
- Improved file count estimation
- Enhanced error handling
- Background rsync processing

### v1.2
- Initial GitHub release
- Basic backup functionality
- Capture One integration