import Foundation
import LocStringCore

public class LocalizationItemImporterFilterDecorator: LocalizationItemImporter {
    private let decoratee: LocalizationItemImporter
    private let filter: (LocalizationItem) -> Bool
    
    public init(decoratee: LocalizationItemImporter, filter: @escaping (LocalizationItem) -> Bool) {
        self.decoratee = decoratee
        self.filter = filter
    }
    
    public func `import`(at url: URL) throws -> [LocalizationItem] {
        return try decoratee
            .import(at: url)
            .filter(filter)
    }
}
