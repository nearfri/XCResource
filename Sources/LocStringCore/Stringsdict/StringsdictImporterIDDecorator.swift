import Foundation

public class StringsdictImporterIDDecorator: StringsdictImporter {
    private let decoratee: StringsdictImporter
    
    public init(decoratee: StringsdictImporter) {
        self.decoratee = decoratee
    }
    
    public func `import`(from plist: Plist) throws -> [LocalizationItem] {
        return try decoratee.import(from: plist).map({ $0.fixingIDForSwift() })
    }
}
