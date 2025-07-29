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

# Optional: Create app bundle for testing
if [ "$1" == "--app" ]; then
    echo "📱 Creating app bundle..."
    rm -rf "JSYNC Backup.app"
    mkdir -p "JSYNC Backup.app"
    cp -R Contents/ "JSYNC Backup.app/"
    chmod +x "JSYNC Backup.app/Contents/Resources/Scripts/main.scpt"
    echo "✅ App bundle created: JSYNC Backup.app"
fi

echo "🚀 Ready for commit and push!"