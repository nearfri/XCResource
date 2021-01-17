import Foundation

struct StringTemplate {
    var key: String
    var arguments: [CVarArg]
}

extension StringTemplate {
    /// 동영상 첨부는 최대 %ld{minutes}분, %@{fileSize}까지 가능합니다.\n다른 파일을 선택해주세요.
    static func alert_attachTooLargeVideo(minutes: Int, fileSize: String) -> StringTemplate {
        return StringTemplate(
            key: StringKey.alert_attachTooLargeVideo.rawValue,
            arguments: [minutes, fileSize])
    }
}
