import Foundation

struct StringKey: Hashable {
    var rawValue: String
    
    init(_ rawValue: String, comment: String) {
        self.rawValue = rawValue
    }
}

extension StringKey {
    /// 음악 추가
    static let editing_menu_addBGM = StringKey("editing_menu_addBGM",
                                               comment: "음악 추가")
}
