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
            
            - case의 rawValue를 key로 하고, "UNTRANSLATED-TEXT"을 value로 하는데 \
            --strategy 옵션에 따라 key나 주석을 value로 할 수 있다.
            - strings 파일에 이미 해당 key가 존재한다면 기존 value를 유지한다.
            - 소스 코드에 없는 key는 strings 파일에서 제거한다.
            """)
    
    // MARK: - Arguments
    
    @Option var swiftPath: String
    
    @Option var resourcesPath: String
    
    @Option var tableName: String = "Localizable"
    
    @Option(name: .customLong("language"),
            parsing: .upToNextOption,
            help: ArgumentHelp(
                "Language to convert.",
                discussion: "If not specified, all languages are converted."))
    var languages: [String] = []
    
    @Option(help: ArgumentHelp(valueName: LocalizableValueStrategy.joinedArgumentName))
    var defaultValueStrategy: LocalizableValueStrategy = .custom("UNTRANSLATED-TEXT")
    
    @Option(name: .customLong("value-strategy"),
            parsing: .upToNextOption,
            help: ArgumentHelp(
                "Value strategy by language.",
                discussion: "If not specified, default-value-strategy is used.",
                valueName: "language:<\(LocalizableValueStrategy.joinedArgumentName)>"))
    var valueStrategyArguments: [ValueStrategyArgument] = []
    
    @Flag var sortByKey: Bool = false
    
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
            languages: languages.isEmpty ? nil : languages.map({ LanguageID($0) }),
            defaultValueStrategy: defaultValueStrategy,
            valueStrategiesByLanguage: valueStrategyArguments.strategiesByLanguage,
            sortOrder: sortByKey ? .key : .occurrence)
        
        return try LocalizableStringsGenerator().generate(for: request)
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
