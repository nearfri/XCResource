import XCTest
@testable import LocStringGen

final class DefaultMethodDeclationGeneratorTests: XCTestCase {
    private let formTypeName: String = "StringForm"
    private let keyTypeName: String = "StringKey"
    
    func test_generate_shortMethod() {
        // Given
        let functionItem = FunctionItem(
            enumCase: .init(
                comments: [
                    .documentLine("%ld{fileCount}개의 파일을 로드하였습니다.")
                ],
                identifier: "fileLoadSuccess",
                rawValue: "fileLoadSuccess"),
            parameters: [
                .init(externalName: "", localName: "fileCount", type: Int.self),
            ])
        
        let expectedDeclation = """
        /// %ld{fileCount}개의 파일을 로드하였습니다.
        static func fileLoadSuccess(fileCount: Int) -> \(formTypeName) {
            return StringForm(key: StringKey.fileLoadSuccess.rawValue, arguments: [fileCount])
        }
        """
        
        let sut = DefaultMethodDeclationGenerator()
        
        // When
        let actualDeclation = sut.generate(formTypeName: formTypeName,
                                           keyTypeName: keyTypeName,
                                           item: functionItem)
        
        // Then
        XCTAssertEqual(actualDeclation, expectedDeclation)
    }
    
    func test_generate_longMethod() {
        // Given
        let functionItem = FunctionItem(
            enumCase: .init(
                comments: [
                    .documentLine(
                        "영상은 최대 %@{videoDuration}, %@{videoFileSize}까지 가능합니다.\\n길이를 수정하세요.")
                ],
                identifier: "errorPopup_overMaximumSize",
                rawValue: "errorPopup_overMaximumSize"),
            parameters: [
                .init(externalName: "", localName: "videoDuration", type: String.self),
                .init(externalName: "", localName: "videoFileSize", type: String.self),
            ])
        
        let expectedDeclation = """
        /// 영상은 최대 %@{videoDuration}, %@{videoFileSize}까지 가능합니다.\\n길이를 수정하세요.
        static func errorPopup_overMaximumSize(
            videoDuration: String,
            videoFileSize: String
        ) -> \(formTypeName) {
            return \(formTypeName)(
                key: StringKey.errorPopup_overMaximumSize.rawValue,
                arguments: [videoDuration, videoFileSize])
        }
        """
        
        let sut = DefaultMethodDeclationGenerator()
        
        // When
        let actualDeclation = sut.generate(formTypeName: formTypeName,
                                           keyTypeName: keyTypeName,
                                           item: functionItem)
        
        // Then
        XCTAssertEqual(actualDeclation, expectedDeclation)
    }
    
    func test_generate_namelessParameter() {
        // Given
        let functionItem = FunctionItem(
            enumCase: .init(
                comments: [
                    .documentLine("영상은 최대 %@, %@까지 가능합니다.\\n길이를 수정하세요.")
                ],
                identifier: "errorPopup_overMaximumSize",
                rawValue: "errorPopup_overMaximumSize"),
            parameters: [
                .init(externalName: "", localName: "", type: String.self),
                .init(externalName: "", localName: "", type: String.self),
            ])
        
        let expectedDeclation = """
        /// 영상은 최대 %@, %@까지 가능합니다.\\n길이를 수정하세요.
        static func errorPopup_overMaximumSize(_ param1: String, _ param2: String) -> \(formTypeName) {
            return \(formTypeName)(
                key: StringKey.errorPopup_overMaximumSize.rawValue,
                arguments: [param1, param2])
        }
        """
        
        let sut = DefaultMethodDeclationGenerator()
        
        // When
        let actualDeclation = sut.generate(formTypeName: formTypeName,
                                           keyTypeName: keyTypeName,
                                           item: functionItem)
        
        // Then
        XCTAssertEqual(actualDeclation, expectedDeclation)
    }
    
    func test_generate_manyParameters() {
        let functionItem = FunctionItem(
            enumCase: .init(
                comments: [
                    .documentLine("%ld %@ %d %f %ld %@ %d %f %ld %@ %d %f")
                ],
                identifier: "manyMany",
                rawValue: "manyMany"),
            parameters: [
                .init(externalName: "", localName: "", type: Int.self),
                .init(externalName: "", localName: "", type: String.self),
                .init(externalName: "", localName: "", type: Int32.self),
                .init(externalName: "", localName: "", type: Double.self),
                .init(externalName: "", localName: "", type: Int.self),
                .init(externalName: "", localName: "", type: String.self),
                .init(externalName: "", localName: "", type: Int32.self),
                .init(externalName: "", localName: "", type: Double.self),
                .init(externalName: "", localName: "", type: Int.self),
                .init(externalName: "", localName: "", type: String.self),
                .init(externalName: "", localName: "", type: Int32.self),
                .init(externalName: "", localName: "", type: Double.self),
            ])
        
        let expectedDeclation = """
        /// %ld %@ %d %f %ld %@ %d %f %ld %@ %d %f
        static func manyMany(
            _ param1: Int,
            _ param2: String,
            _ param3: Int32,
            _ param4: Double,
            _ param5: Int,
            _ param6: String,
            _ param7: Int32,
            _ param8: Double,
            _ param9: Int,
            _ param10: String,
            _ param11: Int32,
            _ param12: Double
        ) -> \(formTypeName) {
            return \(formTypeName)(
                key: StringKey.manyMany.rawValue,
                arguments: [
                    param1, param2, param3, param4, param5, param6, param7, param8, param9, param10,
                    param11, param12
                ])
        }
        """
        
        let sut = DefaultMethodDeclationGenerator()
        
        // When
        let actualDeclation = sut.generate(formTypeName: formTypeName,
                                           keyTypeName: keyTypeName,
                                           item: functionItem)
        
        // Then
        XCTAssertEqual(actualDeclation, expectedDeclation)
    }
    
    func test_generate_documentBlockComment() {
        // Given
        let functionItem = FunctionItem(
            enumCase: .init(
                comments: [
                    .documentBlock("""
                            영상은 최대 %@{duration}, %@{fileSize}까지 가능합니다.
                            길이를 수정하세요.
                            """)
                ],
                identifier: "errorPopup_overMaximumSize",
                rawValue: "errorPopup_overMaximumSize"),
            parameters: [
                .init(externalName: "", localName: "duration", type: String.self),
                .init(externalName: "", localName: "fileSize", type: String.self),
            ])
        
        let expectedDeclation = """
        /**
         영상은 최대 %@{duration}, %@{fileSize}까지 가능합니다.
         길이를 수정하세요.
         */
        static func errorPopup_overMaximumSize(duration: String, fileSize: String) -> \(formTypeName) {
            return \(formTypeName)(
                key: StringKey.errorPopup_overMaximumSize.rawValue,
                arguments: [duration, fileSize])
        }
        """
        
        let sut = DefaultMethodDeclationGenerator()
        
        // When
        let actualDeclation = sut.generate(formTypeName: formTypeName,
                                           keyTypeName: keyTypeName,
                                           item: functionItem)
        
        // Then
        XCTAssertEqual(actualDeclation, expectedDeclation)
    }
    
    func test_generate_manyMethods() {
        // Given
        let functionItems: [FunctionItem] = [
            FunctionItem(
                enumCase: .init(
                    comments: [
                        .documentLine(
                            "영상은 최대 %@{duration}, %@{fileSize}까지 가능합니다.\\n길이를 수정하세요.")
                    ],
                    identifier: "errorPopup_overMaximumSize",
                    rawValue: "errorPopup_overMaximumSize"),
                parameters: [
                    .init(externalName: "", localName: "duration", type: String.self),
                    .init(externalName: "", localName: "fileSize", type: String.self),
                ]),
            FunctionItem(
                enumCase: .init(
                    comments: [
                        .documentLine("%ld{fileCount}개의 파일을 로드하였습니다.")
                    ],
                    identifier: "fileLoadSuccess",
                    rawValue: "fileLoadSuccess"),
                parameters: [
                    .init(externalName: "", localName: "fileCount", type: Int.self),
                ]),
        ]
        
        let expectedDeclations = """
        // MARK: - \(formTypeName) generated from \(keyTypeName)
        
        extension \(formTypeName) {
            /// 영상은 최대 %@{duration}, %@{fileSize}까지 가능합니다.\\n길이를 수정하세요.
            static func errorPopup_overMaximumSize(duration: String, fileSize: String) -> \(formTypeName) {
                return \(formTypeName)(
                    key: StringKey.errorPopup_overMaximumSize.rawValue,
                    arguments: [duration, fileSize])
            }
            
            /// %ld{fileCount}개의 파일을 로드하였습니다.
            static func fileLoadSuccess(fileCount: Int) -> \(formTypeName) {
                return \(formTypeName)(key: StringKey.fileLoadSuccess.rawValue, arguments: [fileCount])
            }
        }
        """
        
        let sut = DefaultMethodDeclationGenerator()
        
        // When
        let actualDeclations = sut.generate(formTypeName: formTypeName,
                                            keyTypeName: keyTypeName,
                                            items: functionItems)
        
        // Then
        XCTAssertEqual(actualDeclations, expectedDeclations)
    }
}

