import Foundation
import LocStringCore
import LocSwiftCore

protocol LocalizationDifferenceCalculator: AnyObject {
    func calculate(
        targetItems: [LocalizationItem],
        baseItems: [LocalizationItem]
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
    private let differenceCalculator: LocalizationDifferenceCalculator
    private let sourceCodeRewriter: LocalizationSourceCodeRewriter
    
    init(stringsImporter: LocalizationItemImporter,
         sourceCodeImporter: LocalizationItemImporter,
         differenceCalculator: LocalizationDifferenceCalculator,
         sourceCodeRewriter: LocalizationSourceCodeRewriter
    ) {
        self.stringsImporter = stringsImporter
        self.sourceCodeImporter = sourceCodeImporter
        self.differenceCalculator = differenceCalculator
        self.sourceCodeRewriter = sourceCodeRewriter
    }
    
    public static func stringsToStringKey() -> StringKeyGenerator {
        return make(
            stringsImporter: StringsImporter(),
            sourceCodeItemFilter: { !$0.commentContainsPluralVariables })
    }
    
    public static func stringsdictToStringKey() -> StringKeyGenerator {
        return make(
            stringsImporter: StringsdictImporter(),
            sourceCodeItemFilter: { $0.commentContainsPluralVariables })
    }
    
    private static func make(
        stringsImporter: LocalizationItemImporter,
        sourceCodeItemFilter: @escaping (LocalizationItem) -> Bool
    ) -> StringKeyGenerator {
        return StringKeyGenerator(
            stringsImporter: LocalizationItemImporterCommentWithValueDecorator(
                decoratee: LocalizationItemImporterIDDecorator(
                    decoratee: stringsImporter)),
            sourceCodeImporter: LocalizationItemImporterFormatLabelRemovalDecorator(
                decoratee: LocalizationItemImporterFilterDecorator(
                    decoratee: SwiftLocalizationItemImporter(
                        enumerationImporter: SwiftStringEnumerationImporter()),
                    filter: sourceCodeItemFilter)),
            differenceCalculator: DefaultLocalizationDifferenceCalculator(),
            sourceCodeRewriter: SwiftLocalizationSourceCodeRewriter())
    }
    
    public func generate(for request: Request) throws -> String {
        let itemsInStrings = try stringsImporter.import(at: request.stringsFileURL)
        
        let itemsInSourceCode = try sourceCodeImporter.import(at: request.sourceCodeURL)
        
        let difference = differenceCalculator.calculate(targetItems: itemsInStrings,
                                                        baseItems: itemsInSourceCode)
        
        return try sourceCodeRewriter.applying(difference, toSourceCodeAt: request.sourceCodeURL)
    }
}
