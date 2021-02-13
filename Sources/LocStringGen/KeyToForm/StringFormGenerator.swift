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
}

public class StringFormGenerator {
    private let enumerationImporter: StringEnumerationImporter
    private let placeholderImporter: FormatPlaceholderImporter
    private let typeDeclationGenerator: TypeDeclarationGenerator
    private let methodDeclationGenerator: MethodDeclationGenerator
    
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
        let typeDeclation = generateTypeDeclation(for: request)
        
        let methodDeclations = try generateMethodDeclations(for: request)
        
        return Result(typeDeclaration: typeDeclation, methodDeclarations: methodDeclations)
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
                .map({ try placeholderImporter.import(from: $0) })
                .flatMap({ try $0.toFunctionParameters() })
            
            return params.isEmpty ? nil : FunctionItem(enumCase: enumCase, parameters: params)
        }
        
        return methodDeclationGenerator.generate(
            formTypeName: request.formTypeName,
            keyTypeName: enumeration.identifier,
            items: functionItems)
    }
}
