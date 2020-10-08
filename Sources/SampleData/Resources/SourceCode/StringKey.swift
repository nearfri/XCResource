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
    
    /// 동영상을 움직여 위치를 조정해보세요.
    static let editMenu_aspectRatioGuide = StringKey("editMenu_aspectRatioGuide",
                                                     comment: "동영상을 움직여 위치를 조정해보세요.")
    
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
    
    /// 동영상 편집을 취소하시겠습니까?\n확인 선택 시 모든 변경사항이 사라집니다.
    static let errorPopup_cancelToEditAsset = StringKey(
        "errorPopup_cancelToEditAsset",
        comment: "동영상 편집을 취소하시겠습니까?\n확인 선택 시 모든 변경사항이 사라집니다.")
    
    /// 동영상을 불러오는 데 실패했습니다.\n다시 시도해주세요.
    static let errorPopup_failToAttach = StringKey(
        "errorPopup_failToAttach", comment: "동영상을 불러오는 데 실패했습니다.\n다시 시도해주세요.")
    
    /// 편집할 수 없는 유형의 영상입니다.\n다른 영상을 첨부해주세요.
    static let errorPopup_failToLoadAsset = StringKey(
        "errorPopup_failToLoadAsset", comment: "편집할 수 없는 유형의 영상입니다.\n다른 영상을 첨부해주세요.")
    
    /// 목록을 불러오는 데 실패했습니다.\n다시 시도해주세요.
    static let errorPopup_failToLoadBGMList = StringKey(
        "errorPopup_failToLoadBGMList", comment: "목록을 불러오는 데 실패했습니다.\n다시 시도해주세요.")
    
    /// 인코딩 오류입니다.\n다시 시도하시겠습니까?
    static let errorPopup_failToEncoding = StringKey(
        "errorPopup_failToEncoding", comment: "인코딩 오류입니다.\n다시 시도하시겠습니까?")
    
    /// 영상은 최대 %@시간, %@까지 가능합니다.\n길이를 수정하세요.
    static let errorPopup_overMaximumSize = StringKey(
        "errorPopup_overMaximumSize", comment: "영상은 최대 %@시간, %@까지 가능합니다.\n길이를 수정하세요.")
}
