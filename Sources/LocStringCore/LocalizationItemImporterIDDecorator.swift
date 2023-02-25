import Foundation

public class LocalizationItemImporterIDDecorator: LocalizationItemImporter {
    private let decoratee: LocalizationItemImporter
    
    public init(decoratee: LocalizationItemImporter) {
        self.decoratee = decoratee
    }
    
    public func `import`(at url: URL) throws -> [LocalizationItem] {
        return try decoratee.import(at: url).map({ $0.fixingIDForSwift() })
    }
}
