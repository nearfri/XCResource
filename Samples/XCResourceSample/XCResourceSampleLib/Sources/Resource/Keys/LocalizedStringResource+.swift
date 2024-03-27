import Foundation

private class BundleFinder {}

extension LocalizedStringResource {
    /// \"\\(param1)\" will be deleted.\
    /// This action cannot be undone.
    static func alert_delete_file(_ param1: String) -> Self {
        .init("alert_delete_file",
              defaultValue: """
                \"\(param1)\" will be deleted.
                This action cannot be undone.
                """,
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Cancel
    static var common_cancel: Self {
        .init("common_cancel",
              defaultValue: "Cancel",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Confirm
    static var common_confirm: Self {
        .init("common_confirm",
              defaultValue: "Confirm",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Done
    static var common_done: Self {
        .init("common_done",
              defaultValue: "Done",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// \\(param1) ate \\(appleCount) today!
    static func dog_eating_apples(_ param1: String, appleCount: Int) -> Self {
        .init("dog_eating_apples",
              defaultValue: "\(param1) ate \(appleCount) today!",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Copy
    static var editMenu_copy: Self {
        .init("editMenu_copy",
              defaultValue: "Copy",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Cut
    static var editMenu_cut: Self {
        .init("editMenu_cut",
              defaultValue: "Cut",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Paste
    static var editMenu_paste: Self {
        .init("editMenu_paste",
              defaultValue: "Paste",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Redo \\(param1)
    static func editMenu_redo(_ param1: String) -> Self {
        .init("editMenu_redo",
              defaultValue: "Redo \(param1)",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Text Style
    static var editMenu_textStyle: Self {
        .init("editMenu_textStyle",
              defaultValue: "Text Style",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Undo \\(param1)
    static func editMenu_undo(_ param1: String) -> Self {
        .init("editMenu_undo",
              defaultValue: "Undo \(param1)",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// \\(param1) files
    static func fileList_fileCount(_ param1: Int) -> Self {
        .init("fileList_fileCount",
              defaultValue: "\(param1) files",
              bundle: .forClass(BundleFinder.self))
    }
    
    // xcresource:use-raw
    /// 100% success
    static var success100: Self {
        .init("success100",
              defaultValue: "100% success",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Bold
    static var text_bold: Self {
        .init("text_bold",
              defaultValue: "Bold",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Italic
    static var text_italic: Self {
        .init("text_italic",
              defaultValue: "Italic",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Strikethrough
    static var text_strikethrough: Self {
        .init("text_strikethrough",
              defaultValue: "Strikethrough",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Underline
    static var text_underline: Self {
        .init("text_underline",
              defaultValue: "Underline",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Tap here
    static var user_instructions: Self {
        .init("user_instructions",
              defaultValue: "Tap here",
              bundle: .forClass(BundleFinder.self))
    }
}
