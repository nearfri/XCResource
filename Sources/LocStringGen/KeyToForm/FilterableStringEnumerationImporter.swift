import Foundation

class FilterableStringEnumerationImporter: StringEnumerationImporter {
    private let importer: StringEnumerationImporter
    private let commandNameOfExclusion: String?
    
    init(importer: StringEnumerationImporter = SwiftStringEnumerationImporter(),
         commandNameOfExclusion: String?
    ) {
        self.importer = importer
        self.commandNameOfExclusion = commandNameOfExclusion
    }
    
    func `import`(at url: URL) throws -> Enumeration<String> {
        var enumeration = try importer.import(at: url)
        
        if let exclusionFilter = exclusionFilter {
            enumeration.cases.removeAll(where: exclusionFilter)
        }
        
        return enumeration
    }
    
    private var exclusionFilter: ((Enumeration<String>.Case) -> Bool)? {
        guard let commandNameOfExclusion = commandNameOfExclusion else {
            return nil
        }
        
        return { enumCase in
            return enumCase
                .comments
                .filter(\.isForDeveloper)
                .map(\.text)
                .contains(where: { $0.hasPrefix(commandNameOfExclusion) })
        }
    }
}