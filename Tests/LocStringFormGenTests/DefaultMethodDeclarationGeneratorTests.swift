import XCTest
import TestUtil
@testable import LocStringFormGen

final class DefaultMethodDeclarationGeneratorTests: XCTestCase {
    private let formTypeName: String = "StringForm"
    private let keyTypeName: String = "StringKey"
    
    func test_generate_shortMethod() {
        // Given
        let functionItem = FunctionItem(
            enumCase: .init(
                comments: [
                    .documentLine("%ld{fileCount}개의 파일을 로드하였습니다.")
                ],
                name: "fileLoadSuccess",
                rawValue: "fileLoadSuccess"),
            parameters: [
                .init(externalName: "", localName: "fileCount", type: Int.self),
            ])
        
        let expectedDeclaration = """
        /// %ld{fileCount}개의 파일을 로드하였습니다.
        static func fileLoadSuccess(fileCount: Int) -> \(formTypeName) {
            return StringForm(key: StringKey.fileLoadSuccess.rawValue, arguments: [fileCount])
        }
        """
        
        let sut = DefaultMethodDeclarationGenerator()
        
        // When
        let actualDeclaration = sut.generate(formTypeName: formTypeName,
                                             keyTypeName: keyTypeName,
                                             item: functionItem)
        
        // Then
        XCTAssertEqual(actualDeclaration, expectedDeclaration)
    }
    
    func test_generate_longMethod() {
        // Given
        let functionItem = FunctionItem(
            enumCase: .init(
                comments: [
                    .documentLine(
                        "영상은 최대 %@{videoDuration}, %@{videoFileSize}까지 가능합니다.\\n길이를 수정하세요.")
                ],
                name: "errorPopup_overMaximumSize",
                rawValue: "errorPopup_overMaximumSize"),
            parameters: [
                .init(externalName: "", localName: "videoDuration", type: String.self),
                .init(externalName: "", localName: "videoFileSize", type: String.self),
            ])
        
        let expectedDeclaration = """
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
        
        let sut = DefaultMethodDeclarationGenerator()
        
        // When
        let actualDeclaration = sut.generate(formTypeName: formTypeName,
                                             keyTypeName: keyTypeName,
                                             item: functionItem)
        
        // Then
        XCTAssertEqual(actualDeclaration, expectedDeclaration)
    }
    
    func test_generate_namelessParameter() {
        // Given
        let functionItem = FunctionItem(
            enumCase: .init(
                comments: [
                    .documentLine("영상은 최대 %@, %@까지 가능합니다.\\n길이를 수정하세요.")
                ],
                name: "error_overMaximumSize",
                rawValue: "error_overMaximumSize"),
            parameters: [
                .init(externalName: "", localName: "", type: String.self),
                .init(externalName: "", localName: "", type: String.self),
            ])
        
        let expectedDeclaration = """
        /// 영상은 최대 %@, %@까지 가능합니다.\\n길이를 수정하세요.
        static func error_overMaximumSize(_ param1: String, _ param2: String) -> \(formTypeName) {
            return \(formTypeName)(
                key: StringKey.error_overMaximumSize.rawValue,
                arguments: [param1, param2])
        }
        """
        
        let sut = DefaultMethodDeclarationGenerator()
        
        // When
        let actualDeclaration = sut.generate(formTypeName: formTypeName,
                                             keyTypeName: keyTypeName,
                                             item: functionItem)
        
        // Then
        XCTAssertEqual(actualDeclaration, expectedDeclaration)
    }
    
    func test_generate_manyParameters() {
        let functionItem = FunctionItem(
            enumCase: .init(
                comments: [
                    .documentLine("%ld %@ %d %f %ld %@ %d %f %ld %@ %d %f")
                ],
                name: "manyMany",
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
        
        let expectedDeclaration = """
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
        
        let sut = DefaultMethodDeclarationGenerator()
        
        // When
        let actualDeclaration = sut.generate(formTypeName: formTypeName,
                                             keyTypeName: keyTypeName,
                                             item: functionItem)
        
        // Then
        XCTAssertEqual(actualDeclaration, expectedDeclaration)
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
                name: "error_overMaximumSize",
                rawValue: "error_overMaximumSize"),
            parameters: [
                .init(externalName: "", localName: "duration", type: String.self),
                .init(externalName: "", localName: "fileSize", type: String.self),
            ])
        
        let expectedDeclaration = """
        /**
         영상은 최대 %@{duration}, %@{fileSize}까지 가능합니다.
         길이를 수정하세요.
         */
        static func error_overMaximumSize(duration: String, fileSize: String) -> \(formTypeName) {
            return \(formTypeName)(
                key: StringKey.error_overMaximumSize.rawValue,
                arguments: [duration, fileSize])
        }
        """
        
        let sut = DefaultMethodDeclarationGenerator()
        
        // When
        let actualDeclaration = sut.generate(formTypeName: formTypeName,
                                             keyTypeName: keyTypeName,
                                             item: functionItem)
        
        // Then
        XCTAssertEqual(actualDeclaration, expectedDeclaration)
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
                    name: "error_overMaximumSize",
                    rawValue: "error_overMaximumSize"),
                parameters: [
                    .init(externalName: "", localName: "duration", type: String.self),
                    .init(externalName: "", localName: "fileSize", type: String.self),
                ]),
            FunctionItem(
                enumCase: .init(
                    comments: [
                        .documentLine("%ld{fileCount}개의 파일을 로드하였습니다.")
                    ],
                    name: "fileLoadSuccess",
                    rawValue: "fileLoadSuccess"),
                parameters: [
                    .init(externalName: "", localName: "fileCount", type: Int.self),
                ]),
        ]
        
        let expectedDeclarations = """
        // MARK: - \(formTypeName) generated from \(keyTypeName)
        
        extension \(formTypeName) {
            /// 영상은 최대 %@{duration}, %@{fileSize}까지 가능합니다.\\n길이를 수정하세요.
            static func error_overMaximumSize(duration: String, fileSize: String) -> \(formTypeName) {
                return \(formTypeName)(
                    key: StringKey.error_overMaximumSize.rawValue,
                    arguments: [duration, fileSize])
            }
            
            /// %ld{fileCount}개의 파일을 로드하였습니다.
            static func fileLoadSuccess(fileCount: Int) -> \(formTypeName) {
                return \(formTypeName)(key: StringKey.fileLoadSuccess.rawValue, arguments: [fileCount])
            }
        }
        """
        
        let sut = DefaultMethodDeclarationGenerator()
        
        // When
        let actualDeclarations = sut.generate(formTypeName: formTypeName,
                                              accessLevel: nil,
                                              keyTypeName: keyTypeName,
                                              items: functionItems)
        
        // Then
        XCTAssertEqual(actualDeclarations, expectedDeclarations)
    }
    
    func test_generate_publicAccessLevel() {
        // Given
        let functionItem = FunctionItem(
            enumCase: .init(
                comments: [
                    .documentLine("%ld{fileCount}개의 파일을 로드하였습니다.")
                ],
                name: "fileLoadSuccess",
                rawValue: "fileLoadSuccess"),
            parameters: [
                .init(externalName: "", localName: "fileCount", type: Int.self),
            ])
        
        let expectedDeclaration = """
        // MARK: - \(formTypeName) generated from \(keyTypeName)
        
        public extension \(formTypeName) {
            /// %ld{fileCount}개의 파일을 로드하였습니다.
            static func fileLoadSuccess(fileCount: Int) -> \(formTypeName) {
                return StringForm(key: StringKey.fileLoadSuccess.rawValue, arguments: [fileCount])
            }
        }
        """
        
        let sut = DefaultMethodDeclarationGenerator()
        
        // When
        let actualDeclaration = sut.generate(formTypeName: formTypeName,
                                             accessLevel: "public",
                                             keyTypeName: keyTypeName,
                                             items: [functionItem])
        
        // Then
        XCTAssertEqual(actualDeclaration, expectedDeclaration)
    }
}

