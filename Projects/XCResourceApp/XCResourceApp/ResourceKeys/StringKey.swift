import Foundation

enum StringKey: String, CaseIterable {
    // MARK: - 일반
    
    /// 취소
    case common_cancel
    
    /// 확인
    case common_confirm
    
    /// 완료
    case common_done
    
    // MARK: - 편집 메뉴
    
    /// 비율
    case editMenu_aspectRatio
    
    /// 동영상을 움직여 위치를 조정해보세요.
    case editMenu_aspectRatioGuide
    
    /// 음악
    case editMenu_bgm
    
    /// 음악 추가
    case editMenu_bgm_placeholder
    
    /// 서명
    case editMenu_copyright
    
    /// 이미지 추가
    case editMenu_copyright_placeholder
    
    /// 필터
    case editMenu_filter
    
    /// 원본
    case editMenu_filter_original
    
    // MARK: - 에러 팝업
    
    /// 동영상 편집을 취소하시겠습니까?\n확인 선택 시 모든 변경사항이 사라집니다.
    case errorPopup_cancelToEditAsset
    
    /// 동영상을 불러오는 데 실패했습니다.\n다시 시도해주세요.
    case errorPopup_failToAttach
    
    /// 편집할 수 없는 유형의 영상입니다.\n다른 영상을 첨부해주세요.
    case errorPopup_failToLoadAsset
    
    /// 목록을 불러오는 데 실패했습니다.\n다시 시도해주세요.
    case errorPopup_failToLoadBGMList
    
    /// 인코딩 오류입니다.\n다시 시도하시겠습니까?
    case errorPopup_failToEncoding
    
    /// 영상은 최대 %@{시간}, %@{용량}까지 가능합니다.\n길이를 수정하세요.
    case errorPopup_overMaximumSize
}
