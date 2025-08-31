import Testing
import Foundation
@testable import XCResourceUtil

@Suite struct URLTests {
    @Test func initWithFilePathExpandingTilde() throws {
        let homeURL = URL(filePath: ("~" as NSString).expandingTildeInPath)
        #expect(homeURL.path.count > 1)
        
        #expect(URL(filePath: "~", expandingTilde: true) == homeURL)
        
        if #unavailable(macOS 26) {
            #expect(URL(filePath: "~", expandingTilde: false) != homeURL)
        }
        
        #expect(URL(filePath: "~", expandingTilde: false) == URL(filePath: "~"))
        
        #expect(URL(filePath: "~/hello/world", expandingTilde: true) ==
                homeURL.appendingPathComponent("hello/world"))
        
        #expect(URL(filePath: "~hello/world", expandingTilde: true) ==
                URL(filePath: "~hello/world"))
        
        #expect(URL(filePath: "hello/world", expandingTilde: true) ==
                URL(filePath: "hello/world"))
        
        #expect(URL(filePath: "/hello/world", expandingTilde: true) ==
                URL(filePath: "/hello/world"))
        
        #expect(URL(filePath: "./hello/world", expandingTilde: true) ==
                URL(filePath: "./hello/world"))
        
        #expect(URL(filePath: "../hello/world", expandingTilde: true) ==
                URL(filePath: "../hello/world"))
    }
}
