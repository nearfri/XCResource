import XCTest
@testable import StaticKeyListGen

final class ActualKeyListFetcherTests: XCTestCase {
    var sut: ActualKeyListFetcher!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = ActualKeyListFetcher()
    }
    
    func test_fetch_validFilename() throws {
        func makeEmptyFile(name: String) throws -> URL {
            let data = Data(repeating: 0, count: 1)
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(name)
            try? FileManager.default.removeItem(at: fileURL)
            try data.write(to: fileURL)
            return fileURL
        }
        
        // Given
        let emptyFileURL = try makeEmptyFile(name: "TestSourceCode.swift")
        
        // When
        let keyList = try sut.fetch(at: emptyFileURL, typeName: "StringKey")
        
        // Then
        XCTAssertEqual(keyList.filename, "TestSourceCode.swift")
        XCTAssertEqual(keyList.typeName, "StringKey")
        XCTAssertEqual(keyList.keys, [])
    }
    
    func test_fetchKeys_definition() throws {
        // Given
        let code = """
        struct StringKey: Hashable {
            var rawValue: String
            
            init(_ rawValue: String, comment: String) {
                self.rawValue = rawValue
            }
            
            /// 음악 추가
            static let editing_menu_addBGM: StringKey = StringKey("editing_menu_addBGM",
                                                                  comment: "음악 추가")
        }
        """
        
        // When
        let keys = try sut.fetchKeys(fromSourceCode: code, typeName: "StringKey")
        
        // Then
        XCTAssertEqual(keys, ["editing_menu_addBGM"])
    }
    
    func test_fetchKeys_extension() throws {
        // Given
        let code = """
        extension StringKey {
            /// 음악 추가
            static let editing_menu_addBGM: StringKey = StringKey("editing_menu_addBGM",
                                                                  comment: "음악 추가")
        }
        """
        
        // When
        let keys = try sut.fetchKeys(fromSourceCode: code, typeName: "StringKey")
        
        // Then
        XCTAssertEqual(keys, ["editing_menu_addBGM"])
    }
    
    func test_fetchKeys_omitTypeName() throws {
        // Given
        let code = """
        extension StringKey {
            static let filterMenu: StringKey = .init("filerMenu", comment: "필터 메뉴")
            static let bgmMenu = StringKey("bgmMenu", comment: "BGM 메뉴")
        }
        """
        
        // When
        let keys = try sut.fetchKeys(fromSourceCode: code, typeName: "StringKey")
        
        // Then
        XCTAssertEqual(keys, ["filterMenu", "bgmMenu"])
    }
    
    func test_fetchKeys_computedProperty() throws {
        // Given
        let code = """
        extension StringKey {
            static var editingMenu { StringKey("editingMenu", comment: "편집 메뉴") }
        }
        """
        
        // When
        let keys = try sut.fetchKeys(fromSourceCode: code, typeName: "StringKey")
        
        // Then
        XCTAssertEqual(keys, ["editingMenu"])
    }
    
    func test_fetchKeys_private() throws {
        // Given
        let code = """
        extension StringKey {
            fileprivate static let editing_menu_addBGM = StringKey("editing_menu_addBGM",
                                                                   comment: "음악 추가")
            private static let editing_menu_addSticker = StringKey("editing_menu_addSticker",
                                                                   comment: "스티커 추가")
        }
        """
        
        // When
        let keys = try sut.fetchKeys(fromSourceCode: code, typeName: "StringKey")
        
        // Then
        XCTAssertEqual(keys, [])
    }
    
    func test_fetchKeys_stringLiteral() throws {
        // Given
        let code = """
        extension ColorKey {
            static let accentColor: ColorKey = "AccentColor"
            
            // MARK: Color
            static let battleshipGrey8: ColorKey = "battleshipGrey8"
        }
        """
        
        // When
        let keys = try sut.fetchKeys(fromSourceCode: code, typeName: "ColorKey")
        
        // Then
        XCTAssertEqual(keys, ["accentColor", "battleshipGrey8"])
    }
    
    func test_fetchKeys_withOtherTypes() throws {
        // Given
        let code = """
        extension StringKey {
            static let accentColor = ColorKey("AccentColor")
            static let bgmMenu = StringKey("bgmMenu", comment: "BGM 메뉴")
            static let errorMessage = String("error occurred")
        }
        """
        
        // When
        let keys = try sut.fetchKeys(fromSourceCode: code, typeName: "StringKey")
        
        // Then
        XCTAssertEqual(keys, ["bgmMenu"])
    }
    
    func test_fetchKeys_inOtherExtension() throws {
        // Given
        let code = """
        extension ColorKey {
            static let accentColor = ColorKey("AccentColor")
            static let bgmMenu = StringKey("bgmMenu", comment: "BGM 메뉴")
            static let errorMessage = String("error occurred")
        }
        """
        
        // When
        let keys = try sut.fetchKeys(fromSourceCode: code, typeName: "StringKey")
        
        // Then
        XCTAssertEqual(keys, [])
    }
}
