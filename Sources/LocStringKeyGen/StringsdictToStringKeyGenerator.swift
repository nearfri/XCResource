import Foundation
import LocStringCore
import LocSwiftCore

extension StringsdictToStringKeyGenerator {
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
    private let differenceCalculator: LocalizationDifferenceCalculator
    private let sourceCodeRewriter: LocalizationSourceCodeRewriter
    
    init(stringsdictImporter: LocalizationItemImporter,
         sourceCodeImporter: LocalizationItemImporter,
         differenceCalculator: LocalizationDifferenceCalculator,
         sourceCodeRewriter: LocalizationSourceCodeRewriter
    ) {
        self.stringsdictImporter = stringsdictImporter
        self.sourceCodeImporter = sourceCodeImporter
        self.differenceCalculator = differenceCalculator
        self.sourceCodeRewriter = sourceCodeRewriter
    }
    
    public convenience init() {
        self.init(
            stringsdictImporter: LocalizationItemImporterCommentWithValueDecorator(
                decoratee: LocalizationItemImporterIDDecorator(
                    decoratee: StringsdictImporter())),
            sourceCodeImporter: LocalizationItemImporterFormatLabelRemovalDecorator(
                decoratee: SwiftLocalizationItemImporter(
                    enumerationImporter: SwiftStringEnumerationImporter())),
            differenceCalculator: DefaultLocalizationDifferenceCalculator(),
            sourceCodeRewriter: SwiftLocalizationSourceCodeRewriter())
    }
    
    public func generate(for request: Request) throws -> String {
        let itemsInStringsdict = try stringsdictImporter.import(at: request.stringsdictFileURL)
        
        let itemsInSourceCode = try sourceCodeImporter.import(at: request.sourceCodeURL)
        
        let filteredItemsInSourceCode = itemsInSourceCode
            .filter({ $0.commentContainsPluralVariables })
        
        let difference = differenceCalculator.calculate(
            targetItems: itemsInStringsdict,
            baseItems: filteredItemsInSourceCode,
            allBaseItems: itemsInSourceCode)
        
        return try sourceCodeRewriter.applying(difference, toSourceCodeAt: request.sourceCodeURL)
    }
}
