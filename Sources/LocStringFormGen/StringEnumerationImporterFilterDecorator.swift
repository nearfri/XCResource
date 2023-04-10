import Foundation
import LocSwiftCore

class StringEnumerationImporterFilterDecorator: StringEnumerationImporter {
    private let decoratee: StringEnumerationImporter
    private let commandNameForExclusion: String
    
    init(decoratee: StringEnumerationImporter = SwiftStringEnumerationImporter(),
         commandNameForExclusion: String
    ) {
        self.decoratee = decoratee
        self.commandNameForExclusion = commandNameForExclusion
    }
    
    func `import`(at url: URL) throws -> Enumeration<String> {
        var enumeration = try decoratee.import(at: url)
        
        enumeration.cases.removeAll { enumCase in
            enumCase.hasCommandName(commandNameForExclusion)
        }
        
        return enumeration
    }
}
