import Foundation
import ArgumentParser

public struct XCResource: ParsableCommand {
    public static let configuration: CommandConfiguration = .init(
        commandName: "xcresource",
        abstract: "A command-line tool for generating type-safe Swift code for resources.",
        discussion: """
            xcresource is a command line tool for generating Swift code from various resources \
            such as localized strings, fonts, and xcassets.
            """,
        version: "1.1.0",
        subcommands: [
            Config.self,
            XCStringsToSwift.self, FontsToSwift.self, FilesToSwift.self, XCAssetsToSwift.self,
        ],
        defaultSubcommand: Config.self)
    
    public init() {}
}
