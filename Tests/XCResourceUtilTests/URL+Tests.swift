import Testing
import Foundation
@testable import XCResourceUtil

@Suite struct URLTests {
    @Test func initWithFileURLWithExpandingTildeInPath() throws {
        let homeURL = URL(fileURLWithPath: ("~" as NSString).expandingTildeInPath)
        #expect(homeURL.path.count > 1)
        
        #expect(URL(fileURLWithExpandingTildeInPath: "~") == homeURL)
        
        #expect(URL(fileURLWithExpandingTildeInPath: "~/hello/world") ==
                homeURL.appendingPathComponent("hello/world"))
        
        #expect(URL(fileURLWithExpandingTildeInPath: "~hello/world") ==
                URL(fileURLWithPath: "~hello/world"))
        
        #expect(URL(fileURLWithExpandingTildeInPath: "hello/world") ==
                URL(fileURLWithPath: "hello/world"))
        
        #expect(URL(fileURLWithExpandingTildeInPath: "/hello/world") ==
                URL(fileURLWithPath: "/hello/world"))
        
        #expect(URL(fileURLWithExpandingTildeInPath: "./hello/world") ==
                URL(fileURLWithPath: "./hello/world"))
        
        #expect(URL(fileURLWithExpandingTildeInPath: "../hello/world") ==
                URL(fileURLWithPath: "../hello/world"))
    }
}
