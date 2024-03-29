import Foundation
import LocStringCore
import LocSwiftCore

extension StringsdictToStringKeyGenerator {
    public struct CommandNameSet {
        public var include: String
        
        public init(include: String) {
            self.include = include
        }
    }
    
    public struct Request {
        public var stringsdictFileURL: URL
        public var sourceCodeURL: URL
        
        public init(
            stringsdictFileURL: URL,
            sourceCodeURL: URL
        ) {
            self.stringsdictFileURL = stringsdictFileURL
            self.sourceCodeURL = sourceCodeURL
        }
    }
}

public class StringsdictToStringKeyGenerator {
    private let stringsdictImporter: LocalizationItemImporter
    private let sourceCodeImporter: LocalizationItemImporter
    private let sourceCodeFilter: LocalizationItemFilter
    private let differenceCalculator: LocalizationDifferenceCalculator
    private let sourceCodeRewriter: LocalizationSourceCodeRewriter
    
    init(stringsdictImporter: LocalizationItemImporter,
         sourceCodeImporter: LocalizationItemImporter,
         sourceCodeFilter: LocalizationItemFilter,
         differenceCalculator: LocalizationDifferenceCalculator,
         sourceCodeRewriter: LocalizationSourceCodeRewriter
    ) {
        self.stringsdictImporter = stringsdictImporter
        self.sourceCodeImporter = sourceCodeImporter
        self.sourceCodeFilter = sourceCodeFilter
        self.differenceCalculator = differenceCalculator
        self.sourceCodeRewriter = sourceCodeRewriter
    }
    
    public convenience init(commandNameSet: CommandNameSet) {
        let sourceCodeItemFilter = StringsdictItemFilter(
            commandNameForInclusion: commandNameSet.include)
        
        self.init(
            stringsdictImporter: LocalizationItemImporterCommentWithValueDecorator(
                decoratee: LocalizationItemImporterIDDecorator(
                    decoratee: DefaultStringsdictImporter())),
            sourceCodeImporter: LocalizationItemImporterFormatLabelRemovalDecorator(
                decoratee: SwiftLocalizationItemImporter(
                    enumerationImporter: SwiftStringEnumerationImporter())),
            sourceCodeFilter: sourceCodeItemFilter,
            differenceCalculator: DefaultLocalizationDifferenceCalculator(),
            sourceCodeRewriter: SwiftLocalizationSourceCodeRewriter(
                lineCommentForItem: sourceCodeItemFilter.lineComment(for:)))
    }
    
    public func generate(for request: Request) throws -> String {
        let itemsInStringsdict = try stringsdictImporter.import(at: request.stringsdictFileURL)
        
        let itemsInSourceCode = try sourceCodeImporter.import(at: request.sourceCodeURL)
        
        let filteredItemsInSourceCode = itemsInSourceCode.filter(sourceCodeFilter.isIncluded(_:))
        
        let difference = differenceCalculator.calculate(
            targetItems: itemsInStringsdict,
            baseItems: filteredItemsInSourceCode,
            allBaseItems: itemsInSourceCode)
        
        return try sourceCodeRewriter.applying(difference, toSourceCodeAt: request.sourceCodeURL)
    }
}
