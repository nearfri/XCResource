import Testing
@testable import AssetKeyGen

@Suite struct AssetTests {
    @Test func key_word() {
        checkComputedKey(name: "hello", key: "hello")
    }
    
    @Test func key_twoWords() {
        checkComputedKey(name: "helloWorld", key: "helloWorld")
        checkComputedKey(name: "URLString", key: "urlString")
        checkComputedKey(name: "downloadURL", key: "downloadURL")
    }
    
    @Test func key_number() {
        checkComputedKey(name: "hello2", key: "hello2")
    }
    
    @Test func key_hangul() {
        checkComputedKey(name: "hello월드", key: "hello월드")
    }
    
    @Test func key_punctuation() {
        checkComputedKey(name: "hello world", key: "hello_world")
        checkComputedKey(name: "hello/world", key: "hello_world")
        checkComputedKey(name: "hello.world", key: "hello_world")
        checkComputedKey(name: "hello_world", key: "hello_world")
    }
    
    @Test func key_path() {
        checkComputedKey(name: "HelloWorld", key: "helloWorld")
        checkComputedKey(name: "Hello/Swift/world", key: "hello_swift_world")
        checkComputedKey(name: "Hello/SwiftWorld", key: "hello_swiftWorld")
        checkComputedKey(name: "Hello/URLString", key: "hello_urlString")
    }
    
    private func checkComputedKey(
        name: String,
        key: String,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        let asset = Asset(name: name, path: "", type: .imageSet)
        #expect(asset.key == key, sourceLocation: sourceLocation)
    }
}
