import Foundation

enum StringKey: String, CaseIterable {
    /// 취소
    case common_cancel
    
    /// 완료
    case common_confirm
    
    /// 편집을 취소하시겠습니까?
    /// 확인 선택 시 모든 변경사항이 사라집니다.
    case errorPopup_cancel_editing = "errorPopup_cancelEditing"
    
    /// 영상은 최대 %d분, %fGB까지 가능합니다.\n길이를 수정하세요.
    case errorPopup_overMaximumSize
}
