import XCTest
import SwiftSyntax
@testable import LocStringResourceGen

final class FunctionParameterSyntaxTests: XCTestCase {
    private typealias Parameter = LocalizationItem.Parameter
    
    func test_initWithParameter_firstNameOnly() throws {
        let param = Parameter(firstName: "dogCount", type: "Int")
        
        XCTAssertEqual(FunctionParameterSyntax(param).description,
                       "dogCount: Int")
    }
    
    func test_initWithParameter_withSecondName() throws {
        let param = Parameter(firstName: "_", secondName: "dogCount", type: "Int")
        
        XCTAssertEqual(FunctionParameterSyntax(param).description,
                       "_ dogCount: Int")
    }
    
    func test_initWithParameter_withIntDefaultValue() throws {
        let param = Parameter(firstName: "dogCount", type: "Int", defaultValue: "1")
        
        XCTAssertEqual(FunctionParameterSyntax(param).description,
                       "dogCount: Int = 1")
    }
    
    func test_initWithParameter_withStringDefaultValue() throws {
        let param = Parameter(firstName: "name", type: "String", defaultValue: "\"John\"")
        
        XCTAssertEqual(FunctionParameterSyntax(param).description,
                       "name: String = \"John\"")
    }
}
