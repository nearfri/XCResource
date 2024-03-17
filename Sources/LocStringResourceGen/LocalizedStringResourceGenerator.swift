import Foundation

extension LocalizedStringResourceGenerator {
    public struct Request {
        public var catalogFileContents: String
        public var table: String?
        public var bundle: LocalizationItem.BundleDescription
        public var sourceCode: String
        public var resourceTypeName: String
        
        public init(
            catalogFileContents: String,
            table: String?,
            bundle: LocalizationItem.BundleDescription,
            sourceCode: String,
            resourceTypeName: String
        ) {
            self.catalogFileContents = catalogFileContents
            self.table = table
            self.bundle = bundle
            self.sourceCode = sourceCode
            self.resourceTypeName = resourceTypeName
        }
    }
}

public class LocalizedStringResourceGenerator {
    private let catalogLoader: LocalizationItemLoader
    private let sourceCodeLoader: LocalizationItemLoader
    private let sourceCodeRewriter: LocalizationSourceCodeRewriter
    
    init(catalogLoader: LocalizationItemLoader,
         sourceCodeLoader: LocalizationItemLoader,
         sourceCodeRewriter: LocalizationSourceCodeRewriter
    ) {
        self.catalogLoader = catalogLoader
        self.sourceCodeLoader = sourceCodeLoader
        self.sourceCodeRewriter = sourceCodeRewriter
    }
    
    public convenience init() {
        self.init(
            catalogLoader: StringCatalogLoader(),
            sourceCodeLoader: SwiftLocalizationItemLoader(),
            sourceCodeRewriter: SwiftLocalizationSourceCodeRewriter())
    }
    
    public func generate(for request: Request) throws -> String {
        let itemsInCatalog = try catalogLoader.load(source: request.catalogFileContents)
        
        return sourceCodeRewriter.rewrite(
            sourceCode: request.sourceCode,
            with: itemsInCatalog,
            resourceTypeName: request.resourceTypeName)
    }
}
