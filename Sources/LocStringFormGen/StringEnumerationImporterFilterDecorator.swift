import Foundation
import LocSwiftCore

class StringEnumerationImporterFilterDecorator: StringEnumerationImporter {
    private let decoratee: StringEnumerationImporter
    private let directiveForExclusion: String
    
    init(decoratee: StringEnumerationImporter = SwiftStringEnumerationImporter(),
         directiveForExclusion: String
    ) {
        self.decoratee = decoratee
        self.directiveForExclusion = directiveForExclusion
    }
    
    func `import`(at url: URL) throws -> Enumeration<String> {
        var enumeration = try decoratee.import(at: url)
        
        enumeration.cases.removeAll { enumCase in
            enumCase.hasCommentDirective(directiveForExclusion)
        }
        
        return enumeration
    }
}
