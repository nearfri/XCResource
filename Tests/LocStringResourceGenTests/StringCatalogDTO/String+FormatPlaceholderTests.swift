import Testing
import StrixParsers
@testable import LocStringResourceGen

@Suite struct String_FormatPlaceholderTests {
    @Test func initWithFormatPlaceholder() throws {
        func test(
            length: FormatPlaceholder.Length?,
            conversion: FormatPlaceholder.Conversion,
            expected: String,
            sourceLocation: SourceLocation = #_sourceLocation
        ) {
            let placeholder = FormatPlaceholder(length: length, conversion: conversion)
            #expect(
                expected == String(formatPlaceholder: placeholder),
                sourceLocation: sourceLocation
            )
        }
        
        test(length: .longLong, conversion: .decimal, expected: "Int")
        test(length: .longLong, conversion: .unsigned, expected: "UInt")
        test(length: nil, conversion: .decimal, expected: "Int32")
        test(length: nil, conversion: .unsigned, expected: "UInt32")
        test(length: .long, conversion: .float, expected: "Double")
        test(length: nil, conversion: .float, expected: "Float")
        test(length: nil, conversion: .object, expected: "String")
    }
}
