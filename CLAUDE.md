# JSYNC Backup - Development Memory

## Project Overview
AppleScript tool for automated Capture One session backups with real-time progress notifications. Distributed as `.scptd` bundle for easy installation in Capture One Scripts folder.

## Current Status ✅
- **Version**: v1.2.7 (latest release)
- **GitHub**: https://github.com/jessemorley/jsync
- **Status**: Production ready with automated releases

## Key Features Implemented
- Real-time backup progress notifications every 10 seconds
- File count estimation and transfer speed display
- Pre-scanning to show accurate progress percentages
- Error handling (disk space, permissions, etc.)
- Custom icon support (jsync.icns)
- Clean release automation via GitHub Actions

## Architecture
```
src/main.applescript              # Source code (edit this)
├── performBackupWithProgress()   # Main backup with notifications
├── parseProgress()              # Parse rsync output for progress
├── parseFinalResults()          # Extract completion stats
└── formatFileSize()             # Human-readable file sizes

Contents/
├── Info.plist                   # Bundle metadata + icon reference
└── Resources/
    ├── Scripts/main.scpt        # Compiled (auto-generated)
    └── jsync.icns              # Custom icon
```

## Development Workflow
1. **Edit**: `src/main.applescript` 
2. **Build**: `./build.sh --bundle` (creates local test bundle)
3. **Test**: Move bundle to `~/Library/Scripts/Capture One Scripts/`
4. **Release**: `git tag vX.X.X && git push --tags` (auto-builds)

## Installation (for users)
1. Download `JSYNC-Backup-vX.X.X.zip` from GitHub releases
2. Unzip and move `JSYNC Backup.scptd` to `~/Library/Scripts/Capture One Scripts/`
3. Access from Capture One Scripts menu

## Technical Notes
- **GitHub Actions**: Uses `macos-14`, creates clean `.scptd` bundles
- **Progress Monitoring**: Parses `rsync --progress` output every 3 seconds
- **Notifications**: macOS native notifications, no modal dialogs
- **File Estimation**: `find` command counts total files for percentage
- **Bundle Structure**: Only includes Info.plist, main.scpt, and jsync.icns

## Recent Changes (v1.2.7)
- Added custom icon support via CFBundleIconFile
- Fixed installation instructions (manual move, not double-click)
- Clean release bundles with only necessary files
- GitHub Actions permissions and deprecation fixes

## Potential Future Enhancements
- Website download link using GitHub latest release API
- Code signing for enterprise distribution
- Additional backup options/preferences
- Integration with other photo management apps

## Quick Commands
```bash
# Local development
./build.sh                    # Compile only
./build.sh --bundle          # Create test bundle

# Release
git tag v1.2.8 && git push --tags

# Check releases
open https://github.com/jessemorley/jsync/releases
```

---
*Last updated: v1.2.7 - Icon support and corrected installation instructions*