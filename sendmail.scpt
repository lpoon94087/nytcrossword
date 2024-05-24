-- Usage <script> recipientName recipientAddress emailSubject emailBody attachmentPath
on run argv
    -- Extract arguments
    set recipientName to item 1 of argv
    set recipientAddress to item 2 of argv
    set emailSubject to item 3 of argv
    set emailBody to item 4 of argv
    set attachmentPath to item 5 of argv

    tell application "Mail"
    
        set theMessage to make new outgoing message with properties {subject:emailSubject, content:emailBody, visible:true}
    
        tell theMessage
            make new to recipient with properties {name:recipientName, address:recipientAddress}
            make new attachment with properties {file name:attachmentPath} at second paragraph
        end tell
        send theMessage
    end tell
end run

