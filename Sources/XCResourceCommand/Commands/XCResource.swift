import Foundation
import ArgumentParser

public struct XCResource: ParsableCommand {
    public static let configuration: CommandConfiguration = .init(
        commandName: "xcresource",
        abstract: "리소스 코드 생성 유틸리티",
        version: "0.12.0",
        subcommands: [
            Config.self,
            XCAssetsToSwift.self, FilesToSwift.self, FontsToSwift.self,
            XCStringsToSwift.self,
        ],
        defaultSubcommand: Config.self)
    
    public init() {}
}
