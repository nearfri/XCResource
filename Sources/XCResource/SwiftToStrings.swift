import Foundation
import ArgumentParser
import LocStringGen
import XCResourceUtil

typealias LocalizableValueStrategy = LocalizableStringsGenerator.ValueStrategy

extension LocalizableValueStrategy: ExpressibleByArgument {
    public init(argument: String) {
        switch argument {
        case "comment": self = .comment
        case "key":     self = .key
        default:        self = .custom(argument)
        }
    }
    
    public var defaultValueDescription: String {
        switch self {
        case .comment:              return "comment"
        case .key:                  return "key"
        case .custom(let string):   return string
        }
    }
    
    public static var allValueStrings: [String] {
        return ["comment", "key", "custom-string"]
    }
    
    static var joinedArgumentName: String {
        return allValueStrings.joined(separator: "|")
    }
}

struct ValueStrategyEntry: ExpressibleByArgument {
    var language: String
    var strategy: LocalizableValueStrategy
    
    init?(argument: String) {
        guard let separatorIndex = argument.firstIndex(of: ":") else { return nil }
        
        let language = argument[..<separatorIndex]
        let strategy = argument[argument.index(after: separatorIndex)...]
        if language.isEmpty || strategy.isEmpty { return nil }
        
        self.language = String(language)
        self.strategy = LocalizableValueStrategy(argument: String(strategy))
    }
}

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
    
    @Option var sourceCodePath: String
    
    @Option var resourcesPath: String
    
    @Option var tableName: String = "Localizable"
    
    @Option(help: ArgumentHelp(valueName: LocalizableValueStrategy.joinedArgumentName))
    var defaultValueStrategy: LocalizableValueStrategy = .custom("UNTRANSLATED-TEXT")
    
    @Option(
        name: .customLong("value-strategy"),
        help: ArgumentHelp(
            valueName: "language:<\(LocalizableValueStrategy.joinedArgumentName)>"))
    var valueStrategies: [ValueStrategyEntry] = []
    
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
            sourceCodeURL: URL(fileURLWithExpandingTildeInPath: sourceCodePath),
            resourcesURL: URL(fileURLWithExpandingTildeInPath: resourcesPath),
            tableName: tableName,
            defaultValueStrategy: defaultValueStrategy,
            valueStrategiesByLanguage: strategiesByLanguage,
            sortOrder: sortByKey ? .key : .occurrence)
        
        return try LocalizableStringsGenerator().generate(for: request)
    }
    
    private var strategiesByLanguage: [LanguageID: LocalizableValueStrategy] {
        return valueStrategies.reduce(into: [:]) { result, entry in
            result[LanguageID(rawValue: entry.language)] = entry.strategy
        }
    }
    
    private func writeStrings(_ strings: String, for language: LanguageID) throws {
        let tempFileURL = FileManager.default.makeTemporaryItemURL()
        var stream = try TextFileOutputStream(forWritingTo: tempFileURL)
        
        print(strings, to: &stream)
        
        try stream.close()
        
        let outputFileURL = stringsFileURL(for: language)
        try FileManager.default.compareAndReplaceItem(at: outputFileURL, withItemAt: tempFileURL)
    }
    
    private func stringsFileURL(for language: LanguageID) -> URL {
        return URL(fileURLWithExpandingTildeInPath: resourcesPath)
            .appendingPathComponents(language: language.rawValue, tableName: tableName)
    }
}
