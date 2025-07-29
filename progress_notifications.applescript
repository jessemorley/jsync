(*
    JSYNC Backup Tool - Progress Notifications Implementation
    Periodic notifications with file count estimation approach
*)

-- Function to perform backup with periodic progress notifications
on performBackupWithProgress(sessionFolder, destinationFolder, tempFile)
    
    -- Step 1: Pre-scan to estimate total files
    display notification "Scanning files..." with title "JSYNC Backup" subtitle "Preparing backup..."
    
    set estimateCommand to "find " & quoted form of sessionFolder & " -type f | wc -l"
    set totalFiles to 0
    try
        set totalFiles to (do shell script estimateCommand) as integer
    on error
        set totalFiles to 0
    end try
    
    -- Step 2: Start rsync with progress flag in background
    set rsyncCommand to "rsync -av --delete --progress --stats " & quoted form of sessionFolder & " " & quoted form of destinationFolder & "/ > " & quoted form of tempFile & " 2>&1 &"
    
    do shell script rsyncCommand
    
    -- Step 3: Monitor progress with periodic notifications
    set startTime to current date
    set lastNotificationTime to startTime
    
    repeat
        delay 3 -- Check every 3 seconds
        
        -- Check if rsync is still running
        set rsyncRunning to false
        try
            do shell script "pgrep -f 'rsync.*" & sessionFolder & "'"
            set rsyncRunning to true
        on error
            -- rsync finished
            exit repeat
        end try
        
        -- Get current progress
        set currentProgress to parseProgress(tempFile, totalFiles)
        set filesProcessed to item 1 of currentProgress
        set currentFile to item 2 of currentProgress
        set transferRate to item 3 of currentProgress
        set progressPercent to item 4 of currentProgress
        
        -- Send notification every 10 seconds or on significant progress
        set currentTime to current date
        set timeSinceLastNotification to (currentTime - lastNotificationTime)
        
        if timeSinceLastNotification >= 10 or progressPercent mod 25 = 0 then
            set progressMessage to "Progress: " & progressPercent & "%"
            if totalFiles > 0 then
                set progressMessage to progressMessage & " (" & filesProcessed & " of " & totalFiles & " files)"
            end if
            
            set subtitleMessage to ""
            if transferRate is not "" then
                set subtitleMessage to "Speed: " & transferRate
            end if
            if currentFile is not "" then
                if subtitleMessage is not "" then
                    set subtitleMessage to subtitleMessage & " • " & currentFile
                else
                    set subtitleMessage to currentFile
                end if
            end if
            
            display notification progressMessage with title "JSYNC Backup" subtitle subtitleMessage
            set lastNotificationTime to currentTime
        end if
        
    end repeat
    
    -- Check if rsync completed successfully
    try
        set rsyncExitCode to do shell script "echo $?"
    on error
        set rsyncExitCode to "0"
    end try
    
    if rsyncExitCode is "0" then
        -- Parse final results
        set finalResults to parseFinalResults(tempFile)
        set numFilesTransferred to item 1 of finalResults
        set totalSizeTransferred to item 2 of finalResults
        set totalBackupSize to item 3 of finalResults
        
        -- Format sizes
        set formattedTransferSize to formatFileSize(totalSizeTransferred)
        set formattedTotalSize to formatFileSize(totalBackupSize)
        
        -- Final success notification
        if numFilesTransferred = "0" then
            set finalMessage to "Backup complete - No new files"
            set finalSubtitle to "Total backup size: " & formattedTotalSize
        else
            set finalMessage to "Backup complete - " & numFilesTransferred & " files copied"
            set finalSubtitle to "Transferred: " & formattedTransferSize & " • Total: " & formattedTotalSize
        end if
        
        display notification finalMessage with title "JSYNC Backup" subtitle finalSubtitle sound name "Glass"
        
        return true
    else
        display notification "Backup failed" with title "JSYNC Backup" subtitle "Check the log file for details" sound name "Basso"
        return false
    end if
    
end performBackupWithProgress

-- Function to parse current progress from rsync output
on parseProgress(tempFile, totalFiles)
    set filesProcessed to 0
    set currentFile to ""
    set transferRate to ""
    set progressPercent to 0
    
    try
        -- Get recent output (last 10 lines)
        set recentOutput to do shell script "tail -10 " & quoted form of tempFile & " 2>/dev/null || echo ''"
        
        -- Parse files processed from "to-check" info
        try
            set checkInfo to do shell script "echo " & quoted form of recentOutput & " | grep -o 'to-check=[0-9]*/[0-9]*' | tail -1"
            if checkInfo is not "" then
                set remainingFiles to (do shell script "echo " & quoted form of checkInfo & " | cut -d'=' -f2 | cut -d'/' -f1") as integer
                set totalFoundFiles to (do shell script "echo " & quoted form of checkInfo & " | cut -d'=' -f2 | cut -d'/' -f2") as integer
                set filesProcessed to totalFoundFiles - remainingFiles
            end if
        end try
        
        -- Parse current file being transferred  
        try
            set currentFile to do shell script "echo " & quoted form of recentOutput & " | grep -E '^[^/]*/' | tail -1 | sed 's/^[ \\t]*//'"
            if length of currentFile > 40 then
                set currentFile to "..." & (text -37 thru -1 of currentFile)
            end if
        end try
        
        -- Parse transfer rate
        try
            set transferRate to do shell script "echo " & quoted form of recentOutput & " | grep -o '[0-9.]*[KMG]B/s' | tail -1"
        end try
        
        -- Calculate percentage
        if totalFiles > 0 and filesProcessed > 0 then
            set progressPercent to round ((filesProcessed / totalFiles) * 100)
            if progressPercent > 100 then set progressPercent to 100
        end if
        
    on error
        -- Keep defaults on error
    end try
    
    return {filesProcessed, currentFile, transferRate, progressPercent}
end parseProgress

-- Function to parse final results
on parseFinalResults(tempFile)
    set numFilesTransferred to "0"
    set totalSizeTransferred to "0"
    set totalBackupSize to "0"
    
    try
        set numFilesTransferred to do shell script "awk '/Number of files transferred:/ {print $NF}' " & quoted form of tempFile & " | grep -Eo '[0-9]+' | head -1 || echo '0'"
        set totalSizeTransferred to do shell script "awk '/Total transferred file size:/ {print $(NF-1)}' " & quoted form of tempFile & " | tr -d '[:space:]' || echo '0'"
        set totalBackupSize to do shell script "awk '/Total file size:/ {print $(NF-1)}' " & quoted form of tempFile & " | tr -d '[:space:]' || echo '0'"
    end try
    
    return {numFilesTransferred, totalSizeTransferred, totalBackupSize}
end parseFinalResults

-- Function to format file sizes
on formatFileSize(fileSizeInBytes)
    try
        set fileSizeInBytes to fileSizeInBytes as number
    on error
        return "Unknown size"
    end try
    
    if fileSizeInBytes ≥ 1.0E+9 then
        set formattedSize to round (fileSizeInBytes / 1.0E+9 * 100) / 100
        return (formattedSize as string) & " GB"
    else if fileSizeInBytes ≥ 1000000 then
        set formattedSize to round (fileSizeInBytes / 1000000)
        return (formattedSize as string) & " MB"
    else
        set formattedSize to round (fileSizeInBytes / 1024)
        return (formattedSize as string) & " KB"
    end if
end formatFileSize

-- Test the progress notifications
set testSource to "/Users/jmorley/Pictures"
set testDest to "/Users/jmorley/Desktop/TestBackup"
set testTempFile to "/Users/jmorley/Desktop/rsync_progress_test.txt"

-- Create destination
do shell script "mkdir -p " & quoted form of testDest

-- Run the backup with progress
set result to performBackupWithProgress(testSource, testDest, testTempFile)

if result then
    display dialog "Progress notification demo completed successfully!" buttons {"OK"} default button "OK"
else
    display dialog "Demo had some issues. Check the temp file for details." buttons {"OK"} default button "OK"
end if