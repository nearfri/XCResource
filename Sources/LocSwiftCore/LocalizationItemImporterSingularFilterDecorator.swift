import Foundation
import LocStringCore

public class LocalizationItemImporterSingularFilterDecorator: LocalizationItemImporter {
    private let decoratee: LocalizationItemImporter
    
    public init(decoratee: LocalizationItemImporter) {
        self.decoratee = decoratee
    }
    
    public func `import`(at url: URL) throws -> [LocalizationItem] {
        return try decoratee
            .import(at: url)
            .filter({ !$0.commentContainsPluralVariables })
    }
}
