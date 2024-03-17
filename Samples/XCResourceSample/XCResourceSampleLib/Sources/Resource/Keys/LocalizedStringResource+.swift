import Foundation

private class BundleFinder {}

extension LocalizedStringResource {
    /// "\\(param1)" will be deleted.\
    /// This action cannot be undone.
    static func alert_delete_file(_ param1: String) -> Self {
        .init("alert_delete_file",
              defaultValue: """
                "\(param1)" will be deleted.
                This action cannot be undone.
                """)
    }
    
    /// Cancel
    static var common_cancel: Self {
        .init("common_cancel",
              defaultValue: "Cancel")
    }
    
    /// Confirm
    static var common_confirm: Self {
        .init("common_confirm",
              defaultValue: "Confirm")
    }
    
    /// Done
    static var common_done: Self {
        .init("common_done",
              defaultValue: "Done")
    }
    
    /// \\(param1) ate \\(appleCount) today!
    static func dog_eating_apples(_ param1: String, appleCount: Int) -> Self {
        .init("dog_eating_apples",
              defaultValue: "\(param1) ate \(appleCount) today!")
    }
    
    /// Copy
    static var editMenu_copy: Self {
        .init("editMenu_copy",
              defaultValue: "Copy")
    }
    
    /// Cut
    static var editMenu_cut: Self {
        .init("editMenu_cut",
              defaultValue: "Cut")
    }
    
    /// Paste
    static var editMenu_paste: Self {
        .init("editMenu_paste",
              defaultValue: "Paste")
    }
    
    /// Redo \\(param1)
    static func editMenu_redo(_ param1: String) -> Self {
        .init("editMenu_redo",
              defaultValue: "Redo \(param1)")
    }
    
    /// Text Style
    static var editMenu_textStyle: Self {
        .init("editMenu_textStyle",
              defaultValue: "Text Style")
    }
    
    /// Undo \\(param1)
    static func editMenu_undo(_ param1: String) -> Self {
        .init("editMenu_undo",
              defaultValue: "Undo \(param1)")
    }
    
    /// \\(param1) files
    static func fileList_fileCount(_ param1: Int) -> Self {
        .init("fileList_fileCount",
              defaultValue: "\(param1) files")
    }
    
    /// 100\\(param1)uccess
    static func success100(_ param1: UnsafePointer<UInt8>) -> Self {
        .init("success100",
              defaultValue: "100\(param1)uccess")
    }
    
    /// Bold
    static var text_bold: Self {
        .init("text_bold",
              defaultValue: "Bold")
    }
    
    /// Italic
    static var text_italic: Self {
        .init("text_italic",
              defaultValue: "Italic")
    }
    
    /// Strikethrough
    static var text_strikethrough: Self {
        .init("text_strikethrough",
              defaultValue: "Strikethrough")
    }
    
    /// Underline
    static var text_underline: Self {
        .init("text_underline",
              defaultValue: "Underline")
    }
    
    /// Tap here
    static var user_instructions: Self {
        .init("user_instructions",
              defaultValue: "Tap here")
    }
}
