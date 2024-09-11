import XCTest
@testable import XCResourceUtil

final class StringTests: XCTestCase {
    func test_toIdentifier() throws {
        XCTAssertEqual("Academy Engraved LET".toIdentifier(), "academyEngravedLET")
        XCTAssertEqual("Academy engraved LET".toIdentifier(), "academyEngravedLET")
        XCTAssertEqual("Academy-engraved-LET".toIdentifier(), "academyEngravedLET")
        XCTAssertEqual("Academy_engraved_LET".toIdentifier(), "academyEngravedLET")
        XCTAssertEqual("1Academy_engraved_LET2".toIdentifier(), "_1AcademyEngravedLET2")
        XCTAssertEqual("SF NS Display".toIdentifier(), "sfNSDisplay")
        XCTAssertEqual(".SF NS Display".toIdentifier(), "sfNSDisplay")
        XCTAssertEqual("SF_NS_Display".toIdentifier(), "sfNSDisplay")
    }
    
    func test_toTypeIdentifier() throws {
        XCTAssertEqual("Academy Engraved LET".toTypeIdentifier(), "AcademyEngravedLET")
        XCTAssertEqual("Academy engraved LET".toTypeIdentifier(), "AcademyEngravedLET")
        XCTAssertEqual("Academy-engraved-LET".toTypeIdentifier(), "AcademyEngravedLET")
        XCTAssertEqual("Academy_engraved_LET".toTypeIdentifier(), "AcademyEngravedLET")
        XCTAssertEqual("1Academy_engraved_LET2".toTypeIdentifier(), "_1AcademyEngravedLET2")
        XCTAssertEqual("SF NS Display".toTypeIdentifier(), "SFNSDisplay")
        XCTAssertEqual(".SF NS Display".toTypeIdentifier(), "SFNSDisplay")
        XCTAssertEqual("SF_NS_Display".toTypeIdentifier(), "SFNSDisplay")
    }
    
    func test_camelCased() {
        XCTAssertEqual("helloWorld".camelCased(), "helloWorld")
        XCTAssertEqual("HelloWorld".camelCased(), "helloWorld")
        XCTAssertEqual("URL".camelCased(), "url")
        XCTAssertEqual("URLs".camelCased(), "urls")
        XCTAssertEqual("URLString".camelCased(), "urlString")
        XCTAssertEqual("urlString".camelCased(), "urlString")
        XCTAssertEqual("downloadURL".camelCased(), "downloadURL")
        XCTAssertEqual("downloadURLString".camelCased(), "downloadURLString")
    }
    
    func test_pascalCased() {
        XCTAssertEqual("helloWorld".pascalCased(), "HelloWorld")
        XCTAssertEqual("HelloWorld".pascalCased(), "HelloWorld")
        XCTAssertEqual("URL".pascalCased(), "URL")
        XCTAssertEqual("URLs".pascalCased(), "URLs")
        XCTAssertEqual("URLString".pascalCased(), "URLString")
        XCTAssertEqual("urlString".pascalCased(), "UrlString")
        XCTAssertEqual("downloadURL".pascalCased(), "DownloadURL")
        XCTAssertEqual("downloadURLString".pascalCased(), "DownloadURLString")
    }
    
    func test_latinCased() {
        XCTAssertEqual("helloWorld".latinCased(), "helloWorld")
        XCTAssertEqual("HelloWorld".latinCased(), "HelloWorld")
        XCTAssertEqual("대한".latinCased(), "daehan")
        XCTAssertEqual("hello대한".latinCased(), "helloDaehan")
        XCTAssertEqual("대한hello".latinCased(), "daehanHello")
        XCTAssertEqual("dh대한san만Regular".latinCased(), "dhDaehanSanManRegular")
        XCTAssertEqual("DH대한san만Regular".latinCased(), "DHDaehanSanManRegular")
    }
    
    func test_addingBackslashEncoding() {
        XCTAssertEqual("ab\"cd".addingBackslashEncoding(), #"ab\"cd"#)
        XCTAssertEqual("ab\\cd".addingBackslashEncoding(), #"ab\cd"#)
        XCTAssertEqual("ab\\ncd".addingBackslashEncoding(), #"ab\ncd"#)
        XCTAssertEqual("ab\ncd".addingBackslashEncoding(), #"ab\ncd"#)
        XCTAssertEqual("ab\rcd".addingBackslashEncoding(), #"ab\rcd"#)
        XCTAssertEqual("ab\tcd".addingBackslashEncoding(), #"ab\tcd"#)
        XCTAssertEqual("ab\u{0008}cd".addingBackslashEncoding(), #"ab\bcd"#)
        XCTAssertEqual("ab\u{000C}cd".addingBackslashEncoding(), #"ab\fcd"#)
    }
    
    func test_addingCSVEncoding() {
        XCTAssertEqual("1997".addingCSVEncoding(), "1997")
        XCTAssertEqual("Ford".addingCSVEncoding(), "Ford")
        XCTAssertEqual("luxurious truck".addingCSVEncoding(), "luxurious truck")
        XCTAssertEqual("luxurious,truck".addingCSVEncoding(), "\"luxurious,truck\"")
        XCTAssertEqual("luxurious\ntruck".addingCSVEncoding(), "\"luxurious\ntruck\"")
        XCTAssertEqual(#"Venture "Extended Edition"."#.addingCSVEncoding(),
                       #""Venture ""Extended Edition"".""#)
    }
    
    func test_appendingPathComponent() {
        XCTAssertEqual("/tmp".appendingPathComponent("scratch.tiff"), "/tmp/scratch.tiff")
        XCTAssertEqual("/tmp/".appendingPathComponent("scratch.tiff"), "/tmp/scratch.tiff")
        XCTAssertEqual("/".appendingPathComponent("scratch.tiff"), "/scratch.tiff")
        XCTAssertEqual("".appendingPathComponent("scratch.tiff"), "scratch.tiff")
        
        XCTAssertEqual("hello".appendingPathComponent("world"), "hello/world")
        
        XCTAssertEqual("hello".appendingPathComponent(""), "hello")
        XCTAssertEqual("".appendingPathComponent("world"), "world")
        
        XCTAssertEqual("hello".appendingPathComponent("/world"), "hello/world")
        XCTAssertEqual("hello/".appendingPathComponent("world"), "hello/world")
        XCTAssertEqual("hello/".appendingPathComponent("/world"), "hello/world")
    }
    
    func test_deletingLastPathComponent() {
        XCTAssertEqual("/tmp/scratch.tiff".deletingLastPathComponent, "/tmp")
        XCTAssertEqual("/tmp/lock/".deletingLastPathComponent, "/tmp")
        XCTAssertEqual("/tmp/".deletingLastPathComponent, "/")
        XCTAssertEqual("/tmp".deletingLastPathComponent, "/")
        XCTAssertEqual("/".deletingLastPathComponent, "/")
        XCTAssertEqual("".deletingLastPathComponent, "")
        XCTAssertEqual("scratch.tiff".deletingLastPathComponent, "")
    }
    
    func test_lastPathComponent() throws {
        XCTAssertEqual("/tmp/scratch.tiff".lastPathComponent, "scratch.tiff")
        XCTAssertEqual("/tmp/scratch".lastPathComponent, "scratch")
        XCTAssertEqual("/tmp/".lastPathComponent, "tmp")
        XCTAssertEqual("scratch///".lastPathComponent, "scratch")
        XCTAssertEqual("/".lastPathComponent, "/")
        XCTAssertEqual("".lastPathComponent, "")
    }
}
