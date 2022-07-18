import Foundation

enum StringKey: String, CaseIterable {
    // MARK: - Common
    
    /// 취소
    case common_cancel
    
    /// 확인
    case common_confirm
    
    // MARK: - Alert
    
    /// 이미지를 불러오는 데 실패했습니다.
    /// 다른 이미지를 선택해주세요.
    case alert_failedToLoadImage = "alert_failed_to_load_image"
    
    /// 동영상 첨부는 최대 %ld분, %@까지 가능합니다.\n다른 파일을 선택해주세요.
    case alert_attachTooLargeVideo
    
    // MARK: - etc.
    
    // xcresource:key2form:exclude
    /// 100% 성공
    case success100
    
    // xcresource:swift2strings:exclude
    /// %{changeCount}ld changes made
    case changeDescription
    
    // Exclude implicitly
    /// My dog ate %#@appleCount@ today!
    case dogEatingApples
}
