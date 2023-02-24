import Foundation
import LocSwiftCore

class StringEnumerationImporterFilterDecorator: StringEnumerationImporter {
    private let decoratee: StringEnumerationImporter
    private let commandNameForExclusion: String?
    
    init(decoratee: StringEnumerationImporter = SwiftStringEnumerationImporter(),
         commandNameForExclusion: String?
    ) {
        self.decoratee = decoratee
        self.commandNameForExclusion = commandNameForExclusion
    }
    
    func `import`(at url: URL) throws -> Enumeration<String> {
        var enumeration = try decoratee.import(at: url)
        
        if let exclusionFilter {
            enumeration.cases.removeAll(where: exclusionFilter)
        }
        
        return enumeration
    }
    
    private var exclusionFilter: ((Enumeration<String>.Case) -> Bool)? {
        guard let commandNameForExclusion else {
            return nil
        }
        
        return { enumCase in
            return enumCase
                .comments
                .filter(\.isForDeveloper)
                .map(\.text)
                .contains(where: { $0.hasPrefix(commandNameForExclusion) })
        }
    }
}
