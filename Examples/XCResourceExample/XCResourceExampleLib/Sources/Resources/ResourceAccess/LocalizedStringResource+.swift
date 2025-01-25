import Foundation

public extension LocalizedStringResource {
    /// \"\\(filename)\" will be deleted.\
    /// This action cannot be undone.
    static func alertDeleteFile(named filename: String) -> Self {
        .init("alert_delete_file",
              defaultValue: """
                \"\(filename)\" will be deleted.
                This action cannot be undone.
                """,
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Cancel
    static var commonCancel: Self {
        .init("common_cancel",
              defaultValue: "Cancel",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Confirm
    static var commonConfirm: Self {
        .init("common_confirm",
              defaultValue: "Confirm",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Done
    static var commonDone: Self {
        .init("common_done",
              defaultValue: "Done",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// \\(dogName) ate \\(appleCount) today!
    static func dogEatingApples(dogName: AttributedString, appleCount: Int) -> Self {
        .init("dog_eating_apples",
              defaultValue: "\(dogName) ate \(appleCount) today!",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    // xcresource:verbatim
    /// %lf works for doubles when formatting.
    static var doubleFormat: Self {
        .init("double_format",
              defaultValue: "%lf works for doubles when formatting.",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Copy
    static var editMenuCopy: Self {
        .init("editMenu_copy",
              defaultValue: "Copy",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Cut
    static var editMenuCut: Self {
        .init("editMenu_cut",
              defaultValue: "Cut",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Paste
    static var editMenuPaste: Self {
        .init("editMenu_paste",
              defaultValue: "Paste",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Redo \\(command)
    static func editMenuRedo(command: String) -> Self {
        .init("editMenu_redo",
              defaultValue: "Redo \(command)",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Text Style
    static var editMenuTextStyle: Self {
        .init("editMenu_textStyle",
              defaultValue: "Text Style",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Undo \\(command)
    static func editMenuUndo(command: String) -> Self {
        .init("editMenu_undo",
              defaultValue: "Undo \(command)",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// \\(fileCount) files
    static func fileListFileCount(_ fileCount: Int) -> Self {
        .init("fileList_fileCount",
              defaultValue: "\(fileCount) files",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Bold
    static var textBold: Self {
        .init("text_bold",
              defaultValue: "Bold",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Italic
    static var textItalic: Self {
        .init("text_italic",
              defaultValue: "Italic",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Strikethrough
    static var textStrikethrough: Self {
        .init("text_strikethrough",
              defaultValue: "Strikethrough",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Underline
    static var textUnderline: Self {
        .init("text_underline",
              defaultValue: "Underline",
              bundle: .atURL(Bundle.module.bundleURL))
    }
    
    /// Tap here
    static var userInstructions: Self {
        .init("user_instructions",
              defaultValue: "Tap here",
              bundle: .atURL(Bundle.module.bundleURL))
    }
}
