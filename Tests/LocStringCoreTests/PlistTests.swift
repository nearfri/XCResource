import XCTest
@testable import LocStringCore

final class PlistTests: XCTestCase {
    // MARK: - initWithXMLElement
    
    func test_initWithXMLElement_string() throws {
        // Given
        let xml = try XMLElement(xmlString: "<string>hello &amp; world</string>")
        
        // When
        let plist = try Plist(xmlElement: xml)
        
        // Then
        XCTAssertEqual(plist, .string("hello & world"))
    }
    
    func test_initWithXMLElement_string_empty() throws {
        // Given
        let xml = try XMLElement(xmlString: "<string></string>")
        
        // When
        let plist = try Plist(xmlElement: xml)
        
        // Then
        XCTAssertEqual(plist, .string(""))
    }
    
    func test_initWithXMLElement_integer() throws {
        // Given
        let xml = try XMLElement(xmlString: "<integer>-7</integer>")
        
        // When
        let plist = try Plist(xmlElement: xml)
        
        // Then
        XCTAssertEqual(plist, .number(NSNumber(value: -7)))
    }
    
    func test_initWithXMLElement_double() throws {
        // Given
        let xml = try XMLElement(xmlString: "<real>3.5</real>")
        
        // When
        let plist = try Plist(xmlElement: xml)
        
        // Then
        XCTAssertEqual(plist, .number(NSNumber(value: 3.5)))
    }
    
    func test_initWithXMLElement_true() throws {
        // Given
        let xml = try XMLElement(xmlString: "<true/>")
        
        // When
        let plist = try Plist(xmlElement: xml)
        
        // Then
        XCTAssertEqual(plist, .bool(true))
    }
    
    func test_initWithXMLElement_false() throws {
        // Given
        let xml = try XMLElement(xmlString: "<false/>")
        
        // When
        let plist = try Plist(xmlElement: xml)
        
        // Then
        XCTAssertEqual(plist, .bool(false))
    }
    
    func test_initWithXMLElement_date() throws {
        // Given
        let dateString = "2023-04-04T02:30:31Z"
        let formatter = ISO8601DateFormatter()
        let date = try XCTUnwrap(formatter.date(from: dateString))
        let xml = try XMLElement(xmlString: "<date>\(dateString)</date>")
        
        // When
        let plist = try Plist(xmlElement: xml)
        
        // Then
        XCTAssertEqual(plist, .date(date))
    }
    
    func test_initWithXMLElement_data() throws {
        // Given
        let data = Data("hello".utf8)
        let base64Encoded = data.base64EncodedString()
        let xml = try XMLElement(xmlString: "<data>\(base64Encoded)</data>")
        
        // When
        let plist = try Plist(xmlElement: xml)
        
        // Then
        XCTAssertEqual(plist, .data(data))
    }
    
    func test_initWithXMLElement_unknown_throwsError() throws {
        // Given
        let xml = try XMLElement(xmlString: "<unknown>hello</unknown>")
        
        // When, Then
        XCTAssertThrowsError(try Plist(xmlElement: xml))
    }
    
    func test_initWithXMLElement_array() throws {
        // Given
        let xml = try XMLElement(xmlString: """
            <array>
                <string>a</string>
                <integer>2</integer>
            </array>
            """)
        
        // When
        let plist = try Plist(xmlElement: xml)
        
        // Then
        XCTAssertEqual(plist, .array([.string("a"), .number(NSNumber(value: 2))]))
    }
    
    func test_initWithXMLElement_array_empty() throws {
        // Given
        let xml = try XMLElement(xmlString: "<array></array>")
        
        // When
        let plist = try Plist(xmlElement: xml)
        
        // Then
        XCTAssertEqual(plist, .array([]))
    }
    
    func test_initWithXMLElement_dictionary() throws {
        // Given
        let xml = try XMLElement(xmlString: """
            <dict>
                <key>zero</key>
                <string>no apples</string>
                <key>one</key>
                <string>one apple</string>
            </dict>
            """)
        
        // When
        let plist = try Plist(xmlElement: xml)
        
        // Then
        XCTAssertEqual(plist, .dictionary([
            "zero": .string("no apples"),
            "one": .string("one apple")
        ]))
    }
    
    func test_initWithXMLDocument() throws {
        // Given
        let xml = try XMLDocument(xmlString: """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <dict>
                <key>First Item</key>
                <string>hello</string>
            </dict>
            </plist>
            """)
        
        // When
        let plist = try Plist(xmlDocument: xml)
        
        // Then
        XCTAssertEqual(plist, .dictionary([
            "First Item": .string("hello"),
        ]))
    }
    
    // MARK: - xmlElement
    
    func test_xmlElement_string() throws {
        // Given
        let plist = Plist.string("hello & world")
        
        // When
        let xml = plist.xmlElement
        
        // Then
        XCTAssertEqual(xml.xmlString, "<string>hello &amp; world</string>")
    }
    
    func test_xmlElement_integer() throws {
        // Given
        let plist = Plist.number(NSNumber(value: -7))
        
        // When
        let xml = plist.xmlElement
        
        // Then
        XCTAssertEqual(xml.xmlString, "<integer>-7</integer>")
    }
    
    func test_xmlElement_double() throws {
        // Given
        let plist = Plist.number(NSNumber(value: 3.5))
        
        // When
        let xml = plist.xmlElement
        
        // Then
        XCTAssertEqual(xml.xmlString, "<real>3.5</real>")
    }
    
    func test_xmlElement_true() throws {
        // Given
        let plist = Plist.bool(true)
        
        // When
        let xml = plist.xmlElement
        
        // Then
        XCTAssertEqual(xml.xmlString(options: .nodeCompactEmptyElement), "<true/>")
    }
    
    func test_xmlElement_false() throws {
        // Given
        let plist = Plist.bool(false)
        
        // When
        let xml = plist.xmlElement
        
        // Then
        XCTAssertEqual(xml.xmlString(options: .nodeCompactEmptyElement), "<false/>")
    }
    
    func test_xmlElement_date() throws {
        // Given
        let dateString = "2023-04-04T02:30:31Z"
        let formatter = ISO8601DateFormatter()
        let date = try XCTUnwrap(formatter.date(from: dateString))
        let plist = Plist.date(date)
        
        // When
        let xml = plist.xmlElement
        
        // Then
        XCTAssertEqual(xml.xmlString, "<date>\(dateString)</date>")
    }
    
    func test_xmlElement_data() throws {
        // Given
        let data = Data("hello".utf8)
        let base64Encoded = data.base64EncodedString()
        let plist = Plist.data(data)
        
        // When
        let xml = plist.xmlElement
        
        // Then
        XCTAssertEqual(xml.xmlString, "<data>\(base64Encoded)</data>")
    }
    
    func test_xmlElement_array() throws {
        // Given
        let plist = Plist.array([
            .string("a"),
            .int(2),
        ])
        
        // When
        let xml = plist.xmlElement
        
        // Then
        XCTAssertEqual(xml.xmlString, "<array><string>a</string><integer>2</integer></array>")
    }
    
    func test_xmlElement_dictionary() throws {
        // Given
        let plist = Plist.dictionary([
            "zero": .string("no apples"),
        ])
        
        // When
        let xml = plist.xmlElement
        
        // Then
        XCTAssertEqual(xml.xmlString, "<dict><key>zero</key><string>no apples</string></dict>")
    }
    
    func test_xmlDocument() throws {
        // Given
        let plist = Plist.dictionary([
            "First Item": .string("hello"),
        ])
        
        // When
        let xml = plist.xmlDocument
        
        // Then
        XCTAssertEqual(xml.xmlString, """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0"><dict><key>First Item</key><string>hello</string></dict></plist>
            """)
    }
    
    // MARK: - xmlElementString
    
    func test_xmlElementString_string() throws {
        // Given
        let plist = Plist.string("hello & world")
        
        // When
        let xmlString = plist.xmlElementString
        
        // Then
        XCTAssertEqual(xmlString, "<string>hello &amp; world</string>")
    }
    
    func test_xmlElementString_array() throws {
        // Given
        let plist = Plist.array([
            .string("hi"),
            .bool(true),
        ])
        
        // When
        let xmlString = plist.xmlElementString
        
        // Then
        XCTAssertEqual(xmlString, """
            <array>
            \t<string>hi</string>
            \t<true/>
            </array>
            """)
    }
    
    func test_xmlElementString_dictionary() throws {
        // Given
        let plist = Plist.dictionary([
            "greeting": .string("hi")
        ])
        
        // When
        let xmlString = plist.xmlElementString
        
        // Then
        XCTAssertEqual(xmlString, """
            <dict>
            \t<key>greeting</key>
            \t<string>hi</string>
            </dict>
            """)
    }
    
    func test_xmlDocumentString() throws {
        // Given
        let plist = Plist.dictionary([
            "greeting": .string("hi")
        ])
        
        // When
        let xmlString = plist.xmlDocumentString
        
        // Then
        XCTAssertEqual(xmlString, """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <dict>
            \t<key>greeting</key>
            \t<string>hi</string>
            </dict>
            </plist>
            """)
    }
}
