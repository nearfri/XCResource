import Foundation

protocol StringEnumerationImporter: AnyObject {
    func `import`(at url: URL) throws -> Enumeration<String>
}

protocol FormatPlaceholderImporter: AnyObject {
    func `import`(from string: String) throws -> [FormatPlaceholder]
}

protocol TypeDeclarationGenerator: AnyObject {
    func generate(formTypeName: String) -> String
}

protocol MethodDeclationGenerator: AnyObject {
    func generate(formTypeName: String, keyTypeName: String, items: [FunctionItem]) -> String
}

extension StringFormGenerator {
    public struct Request {
        public var sourceCodeURL: URL
        public var formTypeName: String
        
        public init(sourceCodeURL: URL, formTypeName: String) {
            self.sourceCodeURL = sourceCodeURL
            self.formTypeName = formTypeName
        }
    }
    
    public struct Result {
        public var typeDeclaration: String
        public var methodDeclarations: String
        
        public init(typeDeclaration: String, methodDeclarations: String) {
            self.typeDeclaration = typeDeclaration
            self.methodDeclarations = methodDeclarations
        }
    }
    
    public enum IssueReporterType: String, CaseIterable {
        case none
        case xcode
        
        func makeIssueReporter() -> IssueReporter? {
            switch self {
            case .none:     return nil
            case .xcode:    return XcodeIssueReporter()
            }
        }
    }
}

public class StringFormGenerator {
    private let enumerationImporter: StringEnumerationImporter
    private let placeholderImporter: FormatPlaceholderImporter
    private let typeDeclationGenerator: TypeDeclarationGenerator
    private let methodDeclationGenerator: MethodDeclationGenerator
    private var issueReporter: IssueReporter?
    
    public var issueReporterType: IssueReporterType = .none {
        didSet {
            issueReporter = issueReporterType.makeIssueReporter()
        }
    }
    
    init(enumerationImporter: StringEnumerationImporter,
         placeholderImporter: FormatPlaceholderImporter,
         typeDeclationGenerator: TypeDeclarationGenerator,
         methodDeclationGenerator: MethodDeclationGenerator
    ) {
        self.enumerationImporter = enumerationImporter
        self.placeholderImporter = placeholderImporter
        self.typeDeclationGenerator = typeDeclationGenerator
        self.methodDeclationGenerator = methodDeclationGenerator
    }
    
    public convenience init() {
        self.init(enumerationImporter: SwiftSourceImporter(),
                  placeholderImporter: ActualFormatPlaceholderImporter(),
                  typeDeclationGenerator: ActualTypeDeclarationGenerator(),
                  methodDeclationGenerator: ActualMethodDeclationGenerator())
    }
    
    public func generate(for request: Request) throws -> Result {
        do {
            let typeDeclation = generateTypeDeclation(for: request)
            
            let methodDeclations = try generateMethodDeclations(for: request)
            
            return Result(typeDeclaration: typeDeclation, methodDeclarations: methodDeclations)
        } catch let error as IssueReportError {
            reportIssue(fileURL: request.sourceCodeURL, error: error)
            throw error
        }
    }
    
    private func generateTypeDeclation(for request: Request) -> String {
        return typeDeclationGenerator.generate(formTypeName: request.formTypeName)
    }
    
    private func generateMethodDeclations(for request: Request) throws -> String {
        let enumeration = try enumerationImporter.import(at: request.sourceCodeURL)
        
        let functionItems: [FunctionItem] = try enumeration.cases.compactMap { enumCase in
            let params = try enumCase
                .comments
                .filter(\.isForDocument)
                .map(\.text)
                .map({ ($0, try placeholderImporter.import(from: $0)) })
                .flatMap({ try makeFunctionParameters(text: $0, formatPlaceholders: $1) })
            
            return params.isEmpty ? nil : FunctionItem(enumCase: enumCase, parameters: params)
        }
        
        return methodDeclationGenerator.generate(
            formTypeName: request.formTypeName,
            keyTypeName: enumeration.identifier,
            items: functionItems)
    }
    
    private func makeFunctionParameters(
        text: String,
        formatPlaceholders: [FormatPlaceholder]
    ) throws -> [FunctionParameter] {
        do {
            return try formatPlaceholders.toFunctionParameters()
        } catch {
            throw IssueReportError(text: text, failureDescription: error.localizedDescription)
        }
    }
    
    private func reportIssue(fileURL: URL, error: IssueReportError) {
        guard let reporter = issueReporter, let issue = Issue(fileURL: fileURL, error: error) else {
            return
        }
        reporter.report(issue)
    }
}