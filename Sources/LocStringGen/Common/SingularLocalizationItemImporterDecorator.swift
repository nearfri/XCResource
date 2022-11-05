import Foundation

class SingularLocalizationItemImporterDecorator: LocalizationItemImporter {
    private let importer: LocalizationItemImporter
    
    init(importer: LocalizationItemImporter) {
        self.importer = importer
    }
    
    func `import`(at url: URL) throws -> [LocalizationItem] {
        return try importer
            .import(at: url)
            .filter({ !$0.commentContainsPluralVariables })
    }
}
