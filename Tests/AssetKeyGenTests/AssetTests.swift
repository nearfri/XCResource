import XCTest
@testable import AssetKeyGen

final class AssetTests: XCTestCase {
    func test_key_word() {
        checkComputedKey(name: "hello", key: "hello")
    }
    
    func checkComputedKey(name: String, key: String,
                          file: StaticString = #filePath, line: UInt = #line) {
        let asset = Asset(name: name, path: "", type: .imageSet)
        XCTAssertEqual(asset.key, key, file: file, line: line)
    }
    
    func test_key_twoWords() {
        checkComputedKey(name: "helloWorld", key: "helloWorld")
        checkComputedKey(name: "URLString", key: "urlString")
        checkComputedKey(name: "downloadURL", key: "downloadURL")
    }
    
    func test_key_number() {
        checkComputedKey(name: "hello2", key: "hello2")
    }
    
    func test_key_hangul() {
        checkComputedKey(name: "hello월드", key: "hello월드")
    }
    
    func test_key_punctuation() {
        checkComputedKey(name: "hello world", key: "hello_world")
        checkComputedKey(name: "hello/world", key: "hello_world")
        checkComputedKey(name: "hello.world", key: "hello_world")
        checkComputedKey(name: "hello_world", key: "hello_world")
    }
    
    func test_key_path() {
        checkComputedKey(name: "HelloWorld", key: "helloWorld")
        checkComputedKey(name: "Hello/Swift/world", key: "hello_swift_world")
        checkComputedKey(name: "Hello/SwiftWorld", key: "hello_swiftWorld")
        checkComputedKey(name: "Hello/URLString", key: "hello_urlString")
    }
}
