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
            
            - case의 rawValue를 key로 하고, "UNLOCALIZED-TEXT"을 value로 하는데 \
            --strategy 옵션에 따라 key나 주석을 value로 할 수 있다.
            - strings 파일에 이미 해당 key가 존재한다면 기존 value를 유지한다.
            - 소스 코드에 없는 key는 strings 파일에서 제거한다.
            """)
    
    // MARK: - Default values
    
    enum Default {
        static let tableName: String = "Localizable"
        static let valueStrategyArguments: [ValueStrategyArgument] = [
            .init(language: LanguageID.allSymbol, strategy: .custom("UNLOCALIZED-TEXT"))
        ]
        static let sortsByKey: Bool = false
    }
    
    // MARK: - Arguments
    
    @Option var swiftPath: String
    
    @Option var resourcesPath: String
    
    @Option var tableName: String = Default.tableName
    
    @Option(name: .customLong("value-strategy"),
            parsing: .upToNextOption,
            help: ArgumentHelp(
                "Value strategies by language to convert.",
                discussion: """
                    If "\(LanguageID.allSymbol)" is specified, all languages are converted.
                    """,
                valueName: "language:<\(LocalizableValueStrategy.joinedValueStrings)>"))
    var valueStrategyArguments: [ValueStrategyArgument] = Default.valueStrategyArguments
    
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
            valueStrategies: valueStrategyArguments.strategiesByLanguage,
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
