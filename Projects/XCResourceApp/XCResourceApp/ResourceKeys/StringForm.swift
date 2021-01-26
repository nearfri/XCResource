import Foundation

struct StringForm {
    var key: String
    var arguments: [CVarArg]
}

extension StringForm {
    /// 동영상 첨부는 최대 %ld{maxMinutes}분, %@{maxFileSize}까지 가능합니다.\n다른 파일을 선택해주세요.
    static func alert_attachTooLargeVideo(maxMinutes: Int, maxFileSize: String) -> StringForm {
        return StringForm(
            key: StringKey.alert_attachTooLargeVideo.rawValue,
            arguments: [maxMinutes, maxFileSize])
    }
}
