import Testing
@testable import Resources

struct ColorKeyTests {
    @Test func colorsExist() throws {
        let keys: [ColorKey] = [
            .cobalt, .lightRose, .marigold
        ]
        
        for key in keys {
            #expect(NativeColor(named: key.name, in: key.bundle) != nil,
                    "\(key.name) color not found")
        }
    }
}
