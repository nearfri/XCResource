import XCTest
import SwiftSyntax
import SwiftParser
@testable import LocStringResourceGen

final class IndentIncreaserTests: XCTestCase {
    func test_indent_singleLineString() throws {
        // Given
        let source = """
            
            let str = "hello world"
            """
        
        let syntax = Parser.parse(source: source)
        
        // When
        let indented = IndentIncreaser.indent(syntax, indentation: .spaces(4))
        
        // Then
        XCTAssertEqual(indented.description, """
            
                let str = "hello world"
            """)
    }
    
    func test_indent_singleLineStringWithNewline() throws {
        // Given
        let source = """
            
            let str = "hello\\nworld\\n"
            """
        
        let syntax = Parser.parse(source: source)
        
        // When
        let indented = IndentIncreaser.indent(syntax, indentation: .spaces(4))
        
        // Then
        XCTAssertEqual(indented.description, """
            
                let str = "hello\\nworld\\n"
            """)
    }
    
    func test_indent_multilineString() throws {
        // Given
        let source = #"""
            
            let str1 = "hello\\nworld\\n"
            let str2 = """
                hello
                world
                """
            """#
        
        let syntax = Parser.parse(source: source)
        
        // When
        let indented = IndentIncreaser.indent(syntax, indentation: .spaces(4))
        
        // Then
        XCTAssertEqual(indented.description, #"""
            
                let str1 = "hello\\nworld\\n"
                let str2 = """
                    hello
                    world
                    """
            """#)
    }
}
