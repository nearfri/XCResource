import Foundation
import ArgumentParser

struct XCResource: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "xcresource",
        abstract: "리소스 코드 생성 유틸리티",
        subcommands: [XCAssetsToSwift.self, SwiftToStrings.self, StringsToCSV.self])
}

XCResource.main()
