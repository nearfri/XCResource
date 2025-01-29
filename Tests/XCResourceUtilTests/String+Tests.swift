import Testing
@testable import XCResourceUtil

@Suite struct StringTests {
    @Test func toIdentifier() throws {
        #expect("Academy Engraved LET".toIdentifier() == "academyEngravedLET")
        #expect("Academy engraved LET".toIdentifier() == "academyEngravedLET")
        #expect("Academy-engraved-LET".toIdentifier() == "academyEngravedLET")
        #expect("Academy_engraved_LET".toIdentifier() == "academyEngravedLET")
        #expect("1Academy_engraved_LET2".toIdentifier() == "_1AcademyEngravedLET2")
        #expect("SF NS Display".toIdentifier() == "sfNSDisplay")
        #expect(".SF NS Display".toIdentifier() == "sfNSDisplay")
        #expect("SF_NS_Display".toIdentifier() == "sfNSDisplay")
    }
    
    @Test func toTypeIdentifier() throws {
        #expect("Academy Engraved LET".toTypeIdentifier() == "AcademyEngravedLET")
        #expect("Academy engraved LET".toTypeIdentifier() == "AcademyEngravedLET")
        #expect("Academy-engraved-LET".toTypeIdentifier() == "AcademyEngravedLET")
        #expect("Academy_engraved_LET".toTypeIdentifier() == "AcademyEngravedLET")
        #expect("1Academy_engraved_LET2".toTypeIdentifier() == "_1AcademyEngravedLET2")
        #expect("SF NS Display".toTypeIdentifier() == "SFNSDisplay")
        #expect(".SF NS Display".toTypeIdentifier() == "SFNSDisplay")
        #expect("SF_NS_Display".toTypeIdentifier() == "SFNSDisplay")
    }
    
    @Test func camelCased() {
        #expect("helloWorld".camelCased() == "helloWorld")
        #expect("HelloWorld".camelCased() == "helloWorld")
        #expect("URL".camelCased() == "url")
        #expect("URLs".camelCased() == "urls")
        #expect("URLString".camelCased() == "urlString")
        #expect("urlString".camelCased() == "urlString")
        #expect("downloadURL".camelCased() == "downloadURL")
        #expect("downloadURLString".camelCased() == "downloadURLString")
    }
    
    @Test func pascalCased() {
        #expect("helloWorld".pascalCased() == "HelloWorld")
        #expect("HelloWorld".pascalCased() == "HelloWorld")
        #expect("URL".pascalCased() == "URL")
        #expect("URLs".pascalCased() == "URLs")
        #expect("URLString".pascalCased() == "URLString")
        #expect("urlString".pascalCased() == "UrlString")
        #expect("downloadURL".pascalCased() == "DownloadURL")
        #expect("downloadURLString".pascalCased() == "DownloadURLString")
    }
    
    @Test func latinCased() {
        #expect("helloWorld".latinCased() == "helloWorld")
        #expect("HelloWorld".latinCased() == "HelloWorld")
        #expect("대한".latinCased() == "daehan")
        #expect("hello대한".latinCased() == "helloDaehan")
        #expect("대한hello".latinCased() == "daehanHello")
        #expect("dh대한san만Regular".latinCased() == "dhDaehanSanManRegular")
        #expect("DH대한san만Regular".latinCased() == "DHDaehanSanManRegular")
    }
    
    @Test func appendingPathComponent() {
        #expect("/tmp".appendingPathComponent("scratch.tiff") == "/tmp/scratch.tiff")
        #expect("/tmp/".appendingPathComponent("scratch.tiff") == "/tmp/scratch.tiff")
        #expect("/".appendingPathComponent("scratch.tiff") == "/scratch.tiff")
        #expect("".appendingPathComponent("scratch.tiff") == "scratch.tiff")
        
        #expect("hello".appendingPathComponent("world") == "hello/world")
        
        #expect("hello".appendingPathComponent("") == "hello")
        #expect("".appendingPathComponent("world") == "world")
        
        #expect("hello".appendingPathComponent("/world") == "hello/world")
        #expect("hello/".appendingPathComponent("world") == "hello/world")
        #expect("hello/".appendingPathComponent("/world") == "hello/world")
    }
    
    @Test func deletingLastPathComponent() {
        #expect("/tmp/scratch.tiff".deletingLastPathComponent == "/tmp")
        #expect("/tmp/lock/".deletingLastPathComponent == "/tmp")
        #expect("/tmp/".deletingLastPathComponent == "/")
        #expect("/tmp".deletingLastPathComponent == "/")
        #expect("/".deletingLastPathComponent == "/")
        #expect("".deletingLastPathComponent == "")
        #expect("scratch.tiff".deletingLastPathComponent == "")
    }
    
    @Test func lastPathComponent() throws {
        #expect("/tmp/scratch.tiff".lastPathComponent == "scratch.tiff")
        #expect("/tmp/scratch".lastPathComponent == "scratch")
        #expect("/tmp/".lastPathComponent == "tmp")
        #expect("scratch///".lastPathComponent == "scratch")
        #expect("/".lastPathComponent == "/")
        #expect("".lastPathComponent == "")
    }
}
