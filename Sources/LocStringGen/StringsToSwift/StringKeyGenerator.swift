import Foundation

protocol LocalizationDifferenceCalculator: AnyObject {
    func calculate(
        sourceItems: [LocalizationItem],
        targetItems: [LocalizationItem]
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
    private let sourceImporter: LocalizationItemImporter
    private let targetImporter: LocalizationItemImporter
    private let differenceCalculator: LocalizationDifferenceCalculator
    private let sourceCodeRewriter: LocalizationSourceCodeRewriter
    
    init(sourceImporter: LocalizationItemImporter,
         targetImporter: LocalizationItemImporter,
         differenceCalculator: LocalizationDifferenceCalculator,
         sourceCodeRewriter: LocalizationSourceCodeRewriter
    ) {
        self.sourceImporter = sourceImporter
        self.targetImporter = targetImporter
        self.differenceCalculator = differenceCalculator
        self.sourceCodeRewriter = sourceCodeRewriter
    }
    
    public func generate(for request: Request) throws -> String {
        let sourceItems = try sourceImporter.import(at: request.stringsFileURL)
        
        let targetItems = try targetImporter
            .import(at: request.sourceCodeURL)
            .filter({ !$0.commentContainsPluralVariables })
        
        let difference = differenceCalculator.calculate(sourceItems: sourceItems,
                                                        targetItems: targetItems)
        
        return try sourceCodeRewriter.applying(difference, toSourceCodeAt: request.sourceCodeURL)
    }
}
