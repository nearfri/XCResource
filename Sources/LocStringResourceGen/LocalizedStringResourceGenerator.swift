import Foundation

protocol CatalogLocalizationItemLoader: AnyObject {
    func load(source: String) throws -> [LocalizationItem]
}

protocol SourceCodeLocalizationItemLoader: AnyObject {
    func load(source: String, resourceTypeName: String) throws -> [LocalizationItem]
}

protocol LocalizationItemMerger: AnyObject {
    func itemsByMerging(
        itemsInCatalog: [LocalizationItem],
        itemsInSourceCode: [LocalizationItem]
    ) -> [LocalizationItem]
}

extension LocalizedStringResourceGenerator {
    public struct CommentDirectives {
        public var verbatim: String
        
        public init(verbatim: String) {
            self.verbatim = verbatim
        }
    }
    
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
    private let catalogLoader: CatalogLocalizationItemLoader
    private let sourceCodeLoader: SourceCodeLocalizationItemLoader
    private let localizationItemMerger: LocalizationItemMerger
    private let sourceCodeRewriter: LocalizationSourceCodeRewriter
    
    init(catalogLoader: CatalogLocalizationItemLoader,
         sourceCodeLoader: SourceCodeLocalizationItemLoader,
         localizationItemMerger: LocalizationItemMerger,
         sourceCodeRewriter: LocalizationSourceCodeRewriter
    ) {
        self.catalogLoader = catalogLoader
        self.sourceCodeLoader = sourceCodeLoader
        self.localizationItemMerger = localizationItemMerger
        self.sourceCodeRewriter = sourceCodeRewriter
    }
    
    public convenience init(commentDirectives: CommentDirectives) {
        self.init(
            catalogLoader: StringCatalogLoader(),
            sourceCodeLoader: SwiftLocalizationItemLoader(),
            localizationItemMerger: DefaultLocalizationItemMerger(
                commentDirectives: .init(verbatim: commentDirectives.verbatim)),
            sourceCodeRewriter: SwiftLocalizationSourceCodeRewriter())
    }
    
    public func generate(for request: Request) throws -> String {
        let itemsInCatalog = try catalogLoader
            .load(source: request.catalogFileContents)
            .map({ item in
                item.with(\.table, request.table)
                    .with(\.bundle, request.bundle)
            })
        
        let itemsInSourceCode = try sourceCodeLoader
            .load(source: request.sourceCode, resourceTypeName: request.resourceTypeName)
        
        let mergedItems = localizationItemMerger.itemsByMerging(
            itemsInCatalog: itemsInCatalog,
            itemsInSourceCode: itemsInSourceCode)
        
        return sourceCodeRewriter.rewrite(
            sourceCode: request.sourceCode,
            with: mergedItems,
            resourceTypeName: request.resourceTypeName)
    }
}
