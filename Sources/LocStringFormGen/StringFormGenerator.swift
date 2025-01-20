import Foundation
import LocSwiftCore

protocol FormatPlaceholderImporter: AnyObject {
    func `import`(from string: String) throws -> [FormatPlaceholder]
}

protocol TypeDeclarationGenerator: AnyObject {
    func generate(formTypeName: String, accessLevel: String?) -> String
}

protocol MethodDeclarationGenerator: AnyObject {
    func generate(formTypeName: String,
                  accessLevel: String?,
                  keyTypeName: String,
                  items: [FunctionItem]) -> String
}

extension StringFormGenerator {
    public struct CommentDirectives {
        public var exclude: String
        
        public init(exclude: String) {
            self.exclude = exclude
        }
    }
    
    public struct Request {
        public var sourceCodeURL: URL
        public var formTypeName: String
        public var accessLevel: String?
        
        public init(sourceCodeURL: URL, formTypeName: String, accessLevel: String?) {
            self.sourceCodeURL = sourceCodeURL
            self.formTypeName = formTypeName
            self.accessLevel = accessLevel
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
    
    public enum IssueReporterType: String, CaseIterable, Sendable {
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
    private let typeDeclarationGenerator: TypeDeclarationGenerator
    private let methodDeclarationGenerator: MethodDeclarationGenerator
    private var issueReporter: IssueReporter?
    
    public var issueReporterType: IssueReporterType = .none {
        didSet {
            issueReporter = issueReporterType.makeIssueReporter()
        }
    }
    
    init(enumerationImporter: StringEnumerationImporter,
         placeholderImporter: FormatPlaceholderImporter,
         typeDeclarationGenerator: TypeDeclarationGenerator,
         methodDeclarationGenerator: MethodDeclarationGenerator
    ) {
        self.enumerationImporter = enumerationImporter
        self.placeholderImporter = placeholderImporter
        self.typeDeclarationGenerator = typeDeclarationGenerator
        self.methodDeclarationGenerator = methodDeclarationGenerator
    }
    
    public convenience init(commentDirectives: CommentDirectives) {
        self.init(
            enumerationImporter: StringEnumerationImporterFilterDecorator(
                decoratee: SwiftStringEnumerationImporter(),
                directiveForExclusion: commentDirectives.exclude),
            placeholderImporter: DefaultFormatPlaceholderImporter(),
            typeDeclarationGenerator: DefaultTypeDeclarationGenerator(),
            methodDeclarationGenerator: DefaultMethodDeclarationGenerator())
    }
    
    public func generate(for request: Request) throws -> Result {
        do {
            let typeDeclaration = generateTypeDeclaration(for: request)
            
            let methodDeclarations = try generateMethodDeclarations(for: request)
            
            return Result(typeDeclaration: typeDeclaration, methodDeclarations: methodDeclarations)
        } catch let error as IssueReportError {
            reportIssue(fileURL: request.sourceCodeURL, error: error)
            throw error
        }
    }
    
    private func generateTypeDeclaration(for request: Request) -> String {
        return typeDeclarationGenerator.generate(formTypeName: request.formTypeName,
                                               accessLevel: request.accessLevel)
    }
    
    private func generateMethodDeclarations(for request: Request) throws -> String {
        let enumeration = try enumerationImporter.import(at: request.sourceCodeURL)
        
        let functionItems: [FunctionItem] = try enumeration.cases.compactMap { enumCase in
            return try makeFunctionItem(enumCase: enumCase)
        }
        
        return methodDeclarationGenerator.generate(
            formTypeName: request.formTypeName,
            accessLevel: request.accessLevel,
            keyTypeName: enumeration.name,
            items: functionItems)
    }
    
    private func makeFunctionItem(enumCase: Enumeration<String>.Case) throws -> FunctionItem? {
        let params = try enumCase
            .comments
            .filter(\.isForDocument)
            .map(\.text)
            .map({ ($0, try placeholderImporter.import(from: $0)) })
            .flatMap({ try makeFunctionParameters(text: $0, formatPlaceholders: $1) })
        
        return params.isEmpty ? nil : FunctionItem(enumCase: enumCase, parameters: params)
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
