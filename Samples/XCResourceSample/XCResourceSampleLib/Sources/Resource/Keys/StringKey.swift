import Foundation

public enum StringKey: String, CaseIterable {
    // MARK: - Common
    
    /// Cancel
    case common_cancel
    
    /// Confirm
    case common_confirm
    
    /// Done
    case common_done
    
    // MARK: - Edit Menu
    
    /// Undo %{command}@
    case editMenu_undo
    
    /// Redo %{command}@
    case editMenu_redo
    
    /// Cut
    case editMenu_cut
    
    /// Copy
    case editMenu_copy
    
    /// Paste
    case editMenu_paste
    
    /// Text Style
    case editMenu_textStyle
    
    // MARK: - Text Style
    
    /// Bold
    case text_bold
    
    /// Italic
    case text_italic
    
    /// Underline
    case text_underline
    
    /// Strikethrough
    case text_strikethrough
    
    // MARK: - File List
    
    /// %{_ fileCount}ld files
    case fileList_fileCount
    
    // MARK: - Alert
    
    /// "%{fileName}@" will be deleted.\n
    /// This action cannot be undone.
    case alert_delete_file
    
    // MARK: - etc.
    
    // xcresource:key2form:exclude - Exclude from StringForm
    /// 100% success
    case success100
    
    // If %#@variable@ format is included,
    // it is implicitly excluded from .strings file and included in .stringsdict file.
    /// %{dogName}@ ate %#@appleCount@ today!
    case dog_eating_apples
    
    // xcresource:target:stringsdict - Include in .stringsdict
    /// Tap here
    case user_instructions
}
