#!/bin/bash

# JSYNC Backup Build Script
# Compiles AppleScript source to binary format

set -e  # Exit on any error

echo "🔨 Building JSYNC Backup..."

# Check if source file exists
if [ ! -f "src/main.applescript" ]; then
    echo "❌ Error: src/main.applescript not found"
    exit 1
fi

# Create directories if they don't exist
mkdir -p "Contents/Resources/Scripts"

# Compile AppleScript
echo "📝 Compiling AppleScript..."
osacompile -o "Contents/Resources/Scripts/main.scpt" "src/main.applescript"

if [ ! -f "Contents/Resources/Scripts/main.scpt" ]; then
    echo "❌ Error: Compilation failed"
    exit 1
fi

echo "✅ Build complete!"
echo "   Source: src/main.applescript"
echo "   Output: Contents/Resources/Scripts/main.scpt"

# Optional: Create script bundle for testing
if [ "$1" == "--bundle" ]; then
    echo "📦 Creating script bundle..."
    rm -rf "JSYNC Backup.scptd"
    mkdir -p "JSYNC Backup.scptd/Contents/Resources/Scripts"
    
    # Copy only necessary files
    cp Contents/Info.plist "JSYNC Backup.scptd/Contents/"
    cp Contents/Resources/Scripts/main.scpt "JSYNC Backup.scptd/Contents/Resources/Scripts/"
    
    chmod +x "JSYNC Backup.scptd/Contents/Resources/Scripts/main.scpt"
    echo "✅ Script bundle created: JSYNC Backup.scptd"
    echo "   Double-click to install in Capture One"
fi

echo "🚀 Ready for commit and push!"