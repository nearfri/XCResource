import Foundation
import LocStringCore
import LocSwiftCore

protocol LocalizationDifferenceCalculator: AnyObject {
    func calculate(
        targetItems: [LocalizationItem],
        baseItems: [LocalizationItem],
        allBaseItems: [LocalizationItem]
    ) -> LocalizationDifference
}

protocol LocalizationSourceCodeRewriter: AnyObject {
    func applying(
        _ difference: LocalizationDifference,
        toSourceCode sourceCode: String
    ) throws -> String
}

extension LocalizationSourceCodeRewriter {
    func applying(_ difference: LocalizationDifference, toSourceCodeAt url: URL) throws -> String {
        let sourceCode = try String(contentsOf: url)
        return try applying(difference, toSourceCode: sourceCode)
    }
}

extension StringKeyGenerator {
    public struct Request {
        public var stringsFileURL: URL
        public var sourceCodeURL: URL
        
        public init(
            stringsFileURL: URL,
            sourceCodeURL: URL
        ) {
            self.stringsFileURL = stringsFileURL
            self.sourceCodeURL = sourceCodeURL
        }
    }
}

public class StringKeyGenerator {
    private let stringsImporter: LocalizationItemImporter
    private let sourceCodeImporter: LocalizationItemImporter
    private let sourceCodeFilter: (LocalizationItem) -> Bool
    private let differenceCalculator: LocalizationDifferenceCalculator
    private let sourceCodeRewriter: LocalizationSourceCodeRewriter
    
    init(stringsImporter: LocalizationItemImporter,
         sourceCodeImporter: LocalizationItemImporter,
         sourceCodeFilter: @escaping (LocalizationItem) -> Bool,
         differenceCalculator: LocalizationDifferenceCalculator,
         sourceCodeRewriter: LocalizationSourceCodeRewriter
    ) {
        self.stringsImporter = stringsImporter
        self.sourceCodeImporter = sourceCodeImporter
        self.sourceCodeFilter = sourceCodeFilter
        self.differenceCalculator = differenceCalculator
        self.sourceCodeRewriter = sourceCodeRewriter
    }
    
    public static func stringsToStringKey() -> StringKeyGenerator {
        return make(
            stringsImporter: StringsImporter(),
            sourceCodeFilter: { !$0.commentContainsPluralVariables })
    }
    
    public static func stringsdictToStringKey() -> StringKeyGenerator {
        return make(
            stringsImporter: StringsdictImporter(),
            sourceCodeFilter: { $0.commentContainsPluralVariables })
    }
    
    private static func make(
        stringsImporter: LocalizationItemImporter,
        sourceCodeFilter: @escaping (LocalizationItem) -> Bool
    ) -> StringKeyGenerator {
        return StringKeyGenerator(
            stringsImporter: LocalizationItemImporterCommentWithValueDecorator(
                decoratee: LocalizationItemImporterIDDecorator(
                    decoratee: stringsImporter)),
            sourceCodeImporter: LocalizationItemImporterFormatLabelRemovalDecorator(
                decoratee: SwiftLocalizationItemImporter(
                    enumerationImporter: SwiftStringEnumerationImporter())),
            sourceCodeFilter: sourceCodeFilter,
            differenceCalculator: DefaultLocalizationDifferenceCalculator(),
            sourceCodeRewriter: SwiftLocalizationSourceCodeRewriter())
    }
    
    public func generate(for request: Request) throws -> String {
        let itemsInStrings = try stringsImporter.import(at: request.stringsFileURL)
        
        let itemsInSourceCode = try sourceCodeImporter.import(at: request.sourceCodeURL)
        let filteredItemsInSourceCode = itemsInSourceCode.filter(sourceCodeFilter)
        
        let difference = differenceCalculator.calculate(
            targetItems: itemsInStrings,
            baseItems: filteredItemsInSourceCode,
            allBaseItems: itemsInSourceCode)
        
        return try sourceCodeRewriter.applying(difference, toSourceCodeAt: request.sourceCodeURL)
    }
}
