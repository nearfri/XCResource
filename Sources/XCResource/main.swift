import Foundation
import ArgumentParser

struct XCResource: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "xcresource",
        abstract: "리소스 코드 생성 유틸리티",
        subcommands: [
            InitManifest.self, RunCommands.self,
            XCAssetsToSwift.self, KeyToForm.self,
            SwiftToStrings.self, StringsToCSV.self, CSVToStrings.self
        ],
        defaultSubcommand: RunCommands.self)
}

XCResource.main()
