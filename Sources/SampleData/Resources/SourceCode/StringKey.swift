import Foundation

struct StringKey: Hashable {
    var rawValue: String
    
    init(_ rawValue: String, comment: String) {
        self.rawValue = rawValue
    }
}

extension StringKey {
    /// 취소
    static let common_cancel = StringKey("common_cancel", comment: "취소")
    
    /// 확인
    static let common_confirm = StringKey("common_confirm", comment: "확인")
    
    /// 완료
    static let common_done = StringKey("common_done", comment: "완료")
    
    /// 비율
    static let editMenu_aspectRatio = StringKey("editMenu_aspectRatio", comment: "비율")
    
    // 음악
    static let editMenu_bgm = StringKey("editMenu_bgm", comment: "음악")
    
    // 음악 추가
    static let editMenu_bgm_placeholder = StringKey("editMenu_bgm_placeholder", comment: "음악 추가")
    
    /// 서명
    static let editMenu_copyright = StringKey("editMenu_copyright", comment: "서명")
    
    /// 이미지 추가
    static let editMenu_copyright_placeholder = StringKey("editMenu_copyright_placeholder",
                                                          comment: "이미지 추가")
    
    /// 필터
    static let editMenu_filter = StringKey("editMenu_filter", comment: "필터")
    
    /// 원본
    static let editMenu_filter_original = StringKey("editMenu_filter_original", comment: "원본")
}
