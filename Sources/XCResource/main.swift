import Foundation
import ArgumentParser

struct XCResource: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "xcresource",
        abstract: "리소스 코드 생성 유틸리티",
        subcommands: [
            InitManifest.self, RunManifest.self,
            XCAssetsToSwift.self, KeyToForm.self,
            SwiftToStrings.self, StringsToCSV.self, CSVToStrings.self
        ],
        defaultSubcommand: RunManifest.self)
}

XCResource.main()
