import Foundation
import ArgumentParser
import LocStringGen
import XCResourceUtil

struct SwiftToStrings: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        commandName: "swift2strings",
        abstract: "Swift 소스 코드를 strings로 변환",
        discussion: """
            enum 타입을 담고 있는 소스 코드에서 case와 주석을 추출해 Localizable.strings 파일을 생성한다.
            
            - case의 rawValue를 key로 하고, --merge-strategy 옵션에 따라 주석이나 custom label을 value로 한다.
            - 소스 코드에 없는 key는 strings 파일에서 제거된다.
            """)
    
    // MARK: - Default values
    
    enum Default {
        static let tableName: String = "Localizable"
        static let mergeStrategies: [LanguageAndMergeStrategy] = [
            .init(language: LanguageID.allSymbol, strategy: .doNotAdd)
        ]
        static let shouldCompareComments: Bool = false
        static let sortsByKey: Bool = false
    }
    
    // MARK: - Arguments
    
    @Option var swiftPath: String
    
    @Option var resourcesPath: String
    
    @Option var tableName: String = Default.tableName
    
    @Option(name: .customLong("merge-strategy"),
            parsing: .upToNextOption,
            help: ArgumentHelp(
                "Merge strategies by language to convert.",
                discussion: """
                    If "\(LanguageID.allSymbol)" is specified, all languages are converted.
                    """,
                valueName: "language:<\(LocalizationMergeStrategy.joinedValueStrings)>"))
    var mergeStrategies: [LanguageAndMergeStrategy] = Default.mergeStrategies
    
    @Flag(name: .customLong("comment-comparison"),
          inversion: .prefixedEnableDisable,
          help: ArgumentHelp(
            "If the flag is enabled and the comments are not equal, the key-value pair is reset."))
    var shouldCompareComments: Bool = Default.shouldCompareComments
    
    @Flag(name: .customLong("sort-by-key"))
    var sortsByKey: Bool = Default.sortsByKey
    
    // MARK: - Run
    
    mutating func run() throws {
        let stringsByLanguage = try generateStrings()
        
        for (language, strings) in stringsByLanguage {
            try writeStrings(strings, for: language)
        }
    }
    
    private func generateStrings() throws -> [LanguageID: String] {
        let request = LocalizableStringsGenerator.Request(
            sourceCodeURL: URL(fileURLWithExpandingTildeInPath: swiftPath),
            resourcesURL: URL(fileURLWithExpandingTildeInPath: resourcesPath),
            tableName: tableName,
            mergeStrategies: mergeStrategies.strategiesByLanguage,
            shouldCompareComments: shouldCompareComments,
            sortOrder: sortsByKey ? .key : .occurrence)
        
        let generator = LocalizableStringsGenerator(
            commandNameSet: .init(exclude: "xcresource:swift2strings:exclude"))
        
        return try generator.generate(for: request)
    }
    
    private func writeStrings(_ strings: String, for language: LanguageID) throws {
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        let outputFileURL = stringsFileURL(for: language)
        
        try (strings + "\n").write(to: tempFileURL, atomically: false, encoding: .utf8)
        try FileManager.default.compareAndReplaceItem(at: outputFileURL, withItemAt: tempFileURL)
    }
    
    private func stringsFileURL(for language: LanguageID) -> URL {
        return URL(fileURLWithExpandingTildeInPath: resourcesPath)
            .appendingPathComponents(language: language.rawValue, tableName: tableName)
    }
}
