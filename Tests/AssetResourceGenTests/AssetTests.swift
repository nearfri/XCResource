import Testing
@testable import AssetResourceGen

@Suite struct AssetTests {
    @Test func id_word() {
        checkComputedID(name: "hello", id: "hello")
    }
    
    @Test func id_twoWords() {
        checkComputedID(name: "helloWorld", id: "helloWorld")
        checkComputedID(name: "URLString", id: "urlString")
        checkComputedID(name: "downloadURL", id: "downloadURL")
    }
    
    @Test func id_number() {
        checkComputedID(name: "hello2", id: "hello2")
    }
    
    @Test func id_hangul() {
        checkComputedID(name: "hello월드", id: "hello월드")
    }
    
    @Test func id_punctuation() {
        checkComputedID(name: "hello world", id: "hello_world")
        checkComputedID(name: "hello/world", id: "hello_world")
        checkComputedID(name: "hello.world", id: "hello_world")
        checkComputedID(name: "hello_world", id: "hello_world")
    }
    
    @Test func id_path() {
        checkComputedID(name: "HelloWorld", id: "helloWorld")
        checkComputedID(name: "Hello/Swift/world", id: "hello_swift_world")
        checkComputedID(name: "Hello/SwiftWorld", id: "hello_swiftWorld")
        checkComputedID(name: "Hello/URLString", id: "hello_urlString")
    }
    
    private func checkComputedID(
        name: String,
        id: String,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        let asset = Asset(name: name, path: "", type: .imageSet)
        #expect(asset.id == id, sourceLocation: sourceLocation)
    }
}
