import XCTest
import StrixParsers
@testable import LocStringResourceGen

final class String_FormatPlaceholderTests: XCTestCase {
    func test_initWithFormatPlacehoder() throws {
        func test(
            length: FormatPlaceholder.Length?,
            conversion: FormatPlaceholder.Conversion,
            expected: String,
            line: UInt = #line
        ) {
            let placeholder = FormatPlaceholder(length: length, conversion: conversion)
            XCTAssertEqual(expected, String(formatPlaceholder: placeholder), line: line)
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
