import Testing
@testable import Resources

struct ColorKeyTests {
    @Test func colorsExist() throws {
        let keys: [ColorKey] = [
            .cobalt, .lightRose, .marigold
        ]
        
        for key in keys {
            #expect(NativeColor(named: key.rawValue, in: .module) != nil,
                    "\(key.rawValue) color not found")
        }
    }
}
