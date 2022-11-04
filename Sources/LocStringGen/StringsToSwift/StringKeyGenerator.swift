import Foundation

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
    
    public convenience init() {
        self.init(
            stringsImporter: ASCIIPlistImporter(),
            sourceCodeImporter: SwiftLocalizationItemImporter(
                enumerationImporter: SwiftStringEnumerationImporter()),
            differenceCalculator: DefaultLocalizationDifferenceCalculator(),
            sourceCodeRewriter: SwiftLocalizationSourceCodeRewriter())
    }
    
    public func generate(for request: Request) throws -> String {
        let itemsInStrings = try stringsImporter.import(at: request.stringsFileURL)
        
        let itemsInSourceCode = try sourceCodeImporter
            .import(at: request.sourceCodeURL)
            .filter({ !$0.commentContainsPluralVariables })
        
        let difference = differenceCalculator.calculate(targetItems: itemsInStrings,
                                                        baseItems: itemsInSourceCode)
        
        return try sourceCodeRewriter.applying(difference, toSourceCodeAt: request.sourceCodeURL)
    }
}
