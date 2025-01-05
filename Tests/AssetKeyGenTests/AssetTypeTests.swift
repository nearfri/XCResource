import Testing
@testable import AssetKeyGen

@Suite struct AssetTypeTests {
    @Test func initWithPathExtension() {
        #expect(AssetType(pathExtension: "imageset") != nil)
        #expect(AssetType(pathExtension: "colorset") != nil)
        #expect(AssetType(pathExtension: "symbolset") != nil)
        
        #expect(AssetType(pathExtension: "imageSet") == nil)
        #expect(AssetType(pathExtension: "images") == nil)
        #expect(AssetType(pathExtension: "image") == nil)
    }
}
