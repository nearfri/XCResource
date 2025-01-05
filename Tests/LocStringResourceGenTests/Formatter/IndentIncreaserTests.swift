import Testing
import SwiftSyntax
import SwiftParser
@testable import LocStringResourceGen

@Suite struct IndentIncreaserTests {
    @Test func indent_singleLineString() throws {
        // Given
        let source = """
            
            let str = "hello world"
            """
        
        let syntax = Parser.parse(source: source)
        
        // When
        let indented = IndentIncreaser.indent(syntax, indentation: .spaces(4))
        
        // Then
        #expect(indented.description == """
            
                let str = "hello world"
            """)
    }
    
    @Test func indent_singleLineStringWithNewline() throws {
        // Given
        let source = """
            
            let str = "hello\\nworld\\n"
            """
        
        let syntax = Parser.parse(source: source)
        
        // When
        let indented = IndentIncreaser.indent(syntax, indentation: .spaces(4))
        
        // Then
        #expect(indented.description == """
            
                let str = "hello\\nworld\\n"
            """)
    }
    
    @Test func indent_multilineString() throws {
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
        #expect(indented.description == #"""
            
                let str1 = "hello\\nworld\\n"
                let str2 = """
                    hello
                    world
                    """
            """#)
    }
}
