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
        let sourceCode = try String(contentsOf: url, encoding: .utf8)
        return try applying(difference, toSourceCode: sourceCode)
    }
}

extension StringsToStringKeyGenerator {
    public struct CommentDirectives {
        public var exclude: String
        
        public init(exclude: String) {
            self.exclude = exclude
        }
    }
    
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

public class StringsToStringKeyGenerator {
    private let stringsImporter: LocalizationItemImporter
    private let sourceCodeImporter: LocalizationItemImporter
    private let sourceCodeFilter: LocalizationItemFilter
    private let differenceCalculator: LocalizationDifferenceCalculator
    private let sourceCodeRewriter: LocalizationSourceCodeRewriter
    
    init(stringsImporter: LocalizationItemImporter,
         sourceCodeImporter: LocalizationItemImporter,
         sourceCodeFilter: LocalizationItemFilter,
         differenceCalculator: LocalizationDifferenceCalculator,
         sourceCodeRewriter: LocalizationSourceCodeRewriter
    ) {
        self.stringsImporter = stringsImporter
        self.sourceCodeImporter = sourceCodeImporter
        self.sourceCodeFilter = sourceCodeFilter
        self.differenceCalculator = differenceCalculator
        self.sourceCodeRewriter = sourceCodeRewriter
    }
    
    public convenience init(commentDirectives: CommentDirectives) {
        let sourceCodeItemFilter = StringsItemFilter(
            directiveForExclusion: commentDirectives.exclude)
        
        self.init(
            stringsImporter: LocalizationItemImporterCommentWithValueDecorator(
                decoratee: LocalizationItemImporterIDDecorator(
                    decoratee: StringsImporter())),
            sourceCodeImporter: LocalizationItemImporterFormatLabelRemovalDecorator(
                decoratee: SwiftLocalizationItemImporter(
                    enumerationImporter: SwiftStringEnumerationImporter())),
            sourceCodeFilter: sourceCodeItemFilter,
            differenceCalculator: DefaultLocalizationDifferenceCalculator(),
            sourceCodeRewriter: SwiftLocalizationSourceCodeRewriter(
                lineCommentForItem: sourceCodeItemFilter.lineComment(for:)))
    }
    
    public func generate(for request: Request) throws -> String {
        let itemsInStrings = try stringsImporter.import(at: request.stringsFileURL)
        
        let itemsInSourceCode = try sourceCodeImporter.import(at: request.sourceCodeURL)
        
        let filteredItemsInSourceCode = itemsInSourceCode.filter(sourceCodeFilter.isIncluded(_:))
        
        let difference = differenceCalculator.calculate(
            targetItems: itemsInStrings,
            baseItems: filteredItemsInSourceCode,
            allBaseItems: itemsInSourceCode)
        
        return try sourceCodeRewriter.applying(difference, toSourceCodeAt: request.sourceCodeURL)
    }
}
