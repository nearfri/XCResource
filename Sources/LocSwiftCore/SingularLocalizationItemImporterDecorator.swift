import Foundation
import LocStringCore

public class SingularLocalizationItemImporterDecorator: LocalizationItemImporter {
    private let importer: LocalizationItemImporter
    
    public init(importer: LocalizationItemImporter) {
        self.importer = importer
    }
    
    public func `import`(at url: URL) throws -> [LocalizationItem] {
        return try importer
            .import(at: url)
            .filter({ !$0.commentContainsPluralVariables })
    }
}
