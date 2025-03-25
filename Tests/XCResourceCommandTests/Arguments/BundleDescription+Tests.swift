import Testing
import LocStringResourceGen
@testable import XCResourceCommand

@Suite struct BundleDescriptionTests {
    private typealias BundleDescription = LocalizationItem.BundleDescription
    
    @Test func defaultValueDescription() throws {
        #expect(BundleDescription(argument: ".main")?.defaultValueDescription == ".main")
    }
}
