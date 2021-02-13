import Foundation

enum StringKey: String, CaseIterable {
    // MARK: - Common
    
    /// 취소
    case common_cancel
    
    /// 확인
    case common_confirm
    
    /// 완료
    case common_done
    
    // MARK: - Edit Menu
    
    /// 실행 취소
    case editMenu_undo
    
    /// 실행 복귀
    case editMenu_redo
    
    /// 오려두기
    case editMenu_cut
    
    /// 복사
    case editMenu_copy
    
    /// 붙여넣기
    case editMenu_paste
    
    // MARK: - Alert
    
    /// 이미지를 불러오는 데 실패했습니다.\n다른 이미지를 선택해주세요.
    case alert_failedToLoadImage
    
    /// 이 새로운 문서('%@{documentTitle}')를 유지하겠습니까?\n변경 사항을 저장하거나 이 문서를 즉시 삭제할 수도 있습니다.
    /// 이 동작은 취소할 수 없습니다.
    case alert_saveBeforeClose
    
    /// 동영상 첨부는 최대 %ld{maxMinutes}분, %@{maxFileSize}까지 가능합니다.\n다른 파일을 선택해주세요.
    case alert_attachTooLargeVideo
}
