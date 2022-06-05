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
    
    /// Undo %@{command}
    case editMenu_undo
    
    /// Redo %@{command}
    case editMenu_redo
    
    /// Cut
    case editMenu_cut
    
    /// Copy
    case editMenu_copy
    
    /// Paste
    case editMenu_paste
    
    // MARK: - File List
    
    /// %ld{_ fileCount} files
    case fileList_fileCount
    
    // MARK: - Alert
    
    /// "%@{fileName}" will be deleted.
    /// This action cannot be undone.
    case alert_deleteFile
    
    // MARK: - etc.
    
    // xcresource:key2form:exclude - Exclude from StringForm
    /// 100% success
    case success100
    
    // If %#@variable@ format is included, it is implicitly excluded from .strings file.
    /// %@{dogName} ate %#@appleCount@ today!
    case dogEatingApples
    
    // xcresource:swift2strings:exclude - Explicitly exclude from .strings.
    /// %ld{changeCount} changes made
    case changeDescription
}