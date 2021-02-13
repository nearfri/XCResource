// This file was generated by xcresource
// Do Not Edit Directly!

struct StringForm {
    var key: String
    var arguments: [CVarArg]
}

// MARK: - StringForm generated from StringKey

extension StringForm {
    /// 이 새로운 문서('%@{documentTitle}')를 유지하겠습니까?\n변경 사항을 저장하거나 이 문서를 즉시 삭제할 수도 있습니다.
    /// 이 동작은 취소할 수 없습니다.
    static func alert_saveBeforeClose(documentTitle: String) -> StringForm {
        return StringForm(key: StringKey.alert_saveBeforeClose.rawValue, arguments: [documentTitle])
    }
    
    /// 동영상 첨부는 최대 %ld{maxMinutes}분, %@{maxFileSize}까지 가능합니다.\n다른 파일을 선택해주세요.
    static func alert_attachTooLargeVideo(maxMinutes: Int, maxFileSize: String) -> StringForm {
        return StringForm(
            key: StringKey.alert_attachTooLargeVideo.rawValue,
            arguments: [maxMinutes, maxFileSize])
    }
}
