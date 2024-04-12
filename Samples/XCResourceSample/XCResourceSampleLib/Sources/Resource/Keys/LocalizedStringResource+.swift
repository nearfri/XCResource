import Foundation

public extension LocalizedStringResource {
    /// \"\\(fileName)\" will be deleted.\
    /// This action cannot be undone.
    static func alert_delete_file(named fileName: String) -> Self {
        .init("alert_delete_file",
              defaultValue: """
                \"\(fileName)\" will be deleted.
                This action cannot be undone.
                """,
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Cancel
    static var common_cancel: Self {
        .init("common_cancel",
              defaultValue: "Cancel",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Confirm
    static var common_confirm: Self {
        .init("common_confirm",
              defaultValue: "Confirm",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Done
    static var common_done: Self {
        .init("common_done",
              defaultValue: "Done",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// \\(dogName) ate \\(appleCount) today!
    static func dog_eating_apples(dogName: String, appleCount: Int) -> Self {
        .init("dog_eating_apples",
              defaultValue: "\(dogName) ate \(appleCount) today!",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Copy
    static var editMenu_copy: Self {
        .init("editMenu_copy",
              defaultValue: "Copy",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Cut
    static var editMenu_cut: Self {
        .init("editMenu_cut",
              defaultValue: "Cut",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Paste
    static var editMenu_paste: Self {
        .init("editMenu_paste",
              defaultValue: "Paste",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Redo \\(command)
    static func editMenu_redo(command: String) -> Self {
        .init("editMenu_redo",
              defaultValue: "Redo \(command)",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Text Style
    static var editMenu_textStyle: Self {
        .init("editMenu_textStyle",
              defaultValue: "Text Style",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Undo \\(command)
    static func editMenu_undo(command: String) -> Self {
        .init("editMenu_undo",
              defaultValue: "Undo \(command)",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// \\(fileCount) files
    static func fileList_fileCount(_ fileCount: Int) -> Self {
        .init("fileList_fileCount",
              defaultValue: "\(fileCount) files",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    // xcresource:use-raw
    /// 100% success
    static var success100: Self {
        .init("success100",
              defaultValue: "100% success",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Bold
    static var text_bold: Self {
        .init("text_bold",
              defaultValue: "Bold",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Italic
    static var text_italic: Self {
        .init("text_italic",
              defaultValue: "Italic",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Strikethrough
    static var text_strikethrough: Self {
        .init("text_strikethrough",
              defaultValue: "Strikethrough",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Underline
    static var text_underline: Self {
        .init("text_underline",
              defaultValue: "Underline",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Tap here
    static var user_instructions: Self {
        .init("user_instructions",
              defaultValue: "Tap here",
              bundle: .atURL(Bundle.module.bundleURL))
    }
}
