import Foundation
import ArgumentParser

struct KeyToFormDTO: CommandDTO {
    static let commandType: ParsableCommand.Type = KeyToForm.self
    
    var keyFilePath: String
    var formFilePath: String
    var formTypeName: String
    var accessLevel: String?
    var excludesTypeDeclaration: Bool?
    var issueReporter: String?
    
    func toCommand() throws -> ParsableCommand {
        typealias Default = KeyToForm.Default
        
        let accessLevel: AccessLevel? = try self.accessLevel.map({
            guard let level = AccessLevel(argument: $0) else {
                throw ValueValidationError(
                    key: CodingKeys.accessLevel.stringValue,
                    value: $0,
                    valueDescription: AccessLevel.joinedAllValuesString)
            }
            return level
        })
        
        let issueReporterType: IssueReporterType? = try issueReporter.map({
            guard let reporter = IssueReporterType(argument: $0) else {
                throw ValueValidationError(
                    key: CodingKeys.issueReporter.stringValue,
                    value: $0,
                    valueDescription: IssueReporterType.joinedAllValuesString)
            }
            return reporter
        })
        
        var command = KeyToForm()
        command.keyFilePath = keyFilePath
        command.formFilePath = formFilePath
        command.formTypeName = formTypeName
        command.accessLevel = accessLevel
        command.excludesTypeDeclaration = excludesTypeDeclaration ?? Default.excludesTypeDeclaration
        command.issueReporterType = issueReporterType ?? Default.issueReporterType
        
        return command
    }
}
