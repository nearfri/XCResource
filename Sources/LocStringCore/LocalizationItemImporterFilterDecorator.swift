import Foundation

public class LocalizationItemImporterFilterDecorator: LocalizationItemImporter {
    private let decoratee: LocalizationItemImporter
    private let filter: LocalizationItemFilter
    
    public init(decoratee: LocalizationItemImporter, filter: LocalizationItemFilter) {
        self.decoratee = decoratee
        self.filter = filter
    }
    
    public func `import`(at url: URL) throws -> [LocalizationItem] {
        return try decoratee
            .import(at: url)
            .filter(filter.isIncluded(_:))
    }
}
