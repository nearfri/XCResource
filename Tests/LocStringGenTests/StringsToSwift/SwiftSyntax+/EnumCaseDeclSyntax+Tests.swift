import XCTest
import SwiftSyntax
@testable import LocStringGen

final class EnumCaseDeclSyntaxTests: XCTestCase {
    // MARK: - initWithLocalizationItem
    
    func test_initWithLocalizationItem_withComment() throws {
        // Given
        let localizationItem = LocalizationItem(
            id: "confirm",
            key: "common_confirm",
            value: "",
            comment: "Confirm")
        
        // When
        let enumCaseDecl = EnumCaseDeclSyntax(localizationItem: localizationItem,
                                              indent: .spaces(4))
        
        // Then
        XCTAssertEqual(enumCaseDecl.description, """
            
                
                /// Confirm
                case confirm = "common_confirm"
            """)
    }
    
    func test_initWithLocalizationItem_withoutComment() throws {
        // Given
        let localizationItem = LocalizationItem(
            id: "confirm",
            key: "common_confirm",
            value: "",
            comment: nil)
        
        // When
        let enumCaseDecl = EnumCaseDeclSyntax(localizationItem: localizationItem,
                                              indent: .spaces(4))
        
        // Then
        XCTAssertEqual(enumCaseDecl.description, "\n    case confirm = \"common_confirm\"")
    }
    
    // MARK: - applyingLocalizationItem
    
    func test_applyingLocalizationItem() throws {
        // Given
        var localizationItem = LocalizationItem(
            id: "confirm",
            key: "common_confirm",
            value: "",
            comment: "Confirm")
        
        let enumCaseDecl = EnumCaseDeclSyntax(localizationItem: localizationItem,
                                              indent: .spaces(4))
        
        localizationItem.comment = "New comment"
        
        // When
        let modifiedEnumCaseDecl = enumCaseDecl.applying(localizationItem)
        
        // Then
        XCTAssertEqual(modifiedEnumCaseDecl.description, """
            
                
                /// New comment
                case confirm = "common_confirm"
            """)
    }
}
