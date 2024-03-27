import Foundation

private class BundleFinder {}

package extension LocalizedStringResource {
    /// \"\\(fileName)\" will be deleted.\
    /// This action cannot be undone.
    static func alert_delete_file(named fileName: String) -> Self {
        .init("alert_delete_file",
              defaultValue: """
                \"\(fileName)\" will be deleted.
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
    
    /// \\(dogName) ate \\(appleCount) today!
    static func dog_eating_apples(dogName: String, appleCount: Int) -> Self {
        .init("dog_eating_apples",
              defaultValue: "\(dogName) ate \(appleCount) today!",
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
    
    /// Redo \\(command)
    static func editMenu_redo(command: String) -> Self {
        .init("editMenu_redo",
              defaultValue: "Redo \(command)",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Text Style
    static var editMenu_textStyle: Self {
        .init("editMenu_textStyle",
              defaultValue: "Text Style",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// Undo \\(command)
    static func editMenu_undo(command: String) -> Self {
        .init("editMenu_undo",
              defaultValue: "Undo \(command)",
              bundle: .forClass(BundleFinder.self))
    }
    
    /// \\(fileCount) files
    static func fileList_fileCount(_ fileCount: Int) -> Self {
        .init("fileList_fileCount",
              defaultValue: "\(fileCount) files",
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
