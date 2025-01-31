import Testing
@testable import Resources

struct ResourceTests {
    @Test func imagesExist() throws {
        let keys: [ImageKey] = [
            .textFormattingLink, .Style.textFormattingBold,
            .Places.authArrow, .Places.Dot.medium,
        ]
        
        for key in keys {
            #expect(NativeImage(named: key.name, in: key.bundle) != nil,
                    "\(key.name) image not found")
        }
    }
}
