import Testing
@testable import Resources

struct ResourceTests {
    @Test func imagesExist() throws {
        let keys: [ImageKey] = [
            .textFormattingLink, .textFormattingBold,
            .places_authArrow, .places_dot_medium
        ]
        
        for key in keys {
            #expect(NativeImage(named: key.rawValue, in: .module) != nil,
                    "\(key.rawValue) image not found")
        }
    }
}
