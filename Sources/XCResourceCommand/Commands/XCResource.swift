import Foundation
import ArgumentParser

public struct XCResource: ParsableCommand {
    public static let configuration: CommandConfiguration = .init(
        commandName: "xcresource",
        abstract: "리소스 코드 생성 유틸리티",
        version: "0.10.0",
        subcommands: [
            InitManifest.self, RunManifest.self,
            XCAssetsToSwift.self, FontsToSwift.self,
            XCStringsToSwift.self, KeyToForm.self,
            SwiftToStrings.self, SwiftToStringsdict.self,
            StringsToSwift.self, StringsdictToSwift.self,
            StringsToCSV.self, CSVToStrings.self,
        ],
        defaultSubcommand: RunManifest.self)
    
    public init() {}
}
