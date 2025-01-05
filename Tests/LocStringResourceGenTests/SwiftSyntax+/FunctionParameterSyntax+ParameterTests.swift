import Testing
import SwiftSyntax
@testable import LocStringResourceGen

@Suite struct FunctionParameterSyntaxTests {
    private typealias Parameter = LocalizationItem.Parameter
    
    @Test func initWithParameter_firstNameOnly() throws {
        let param = Parameter(firstName: "dogCount", type: "Int")
        
        #expect(FunctionParameterSyntax(param).description == "dogCount: Int")
    }
    
    @Test func initWithParameter_withSecondName() throws {
        let param = Parameter(firstName: "_", secondName: "dogCount", type: "Int")
        
        #expect(FunctionParameterSyntax(param).description == "_ dogCount: Int")
    }
    
    @Test func initWithParameter_withIntDefaultValue() throws {
        let param = Parameter(firstName: "dogCount", type: "Int", defaultValue: "1")
        
        #expect(FunctionParameterSyntax(param).description == "dogCount: Int = 1")
    }
    
    @Test func initWithParameter_withStringDefaultValue() throws {
        let param = Parameter(firstName: "name", type: "String", defaultValue: "\"John\"")
        
        #expect(FunctionParameterSyntax(param).description == "name: String = \"John\"")
    }
}
