import Foundation
import XCResourceUtil

public struct LocalizationItem: Equatable, Identifiable, Sendable, SettableByKeyPath {
    public let id: String
    public var key: String
    public var value: String
    public var developerComments: [String]
    public var comment: String?
    
    public init(
        id: String? = nil,
        key: String,
        value: String,
        developerComments: [String] = [],
        comment: String? = nil
    ) {
        self.id = id ?? key
        self.key = key
        self.value = value
        self.developerComments = developerComments
        self.comment = comment
    }
}

extension LocalizationItem {
    public func fixingIDForSwift() -> Self {
        if id.isEmpty { return self }
        
        var newID = ""
        
        let firstChar = id[id.startIndex]
        if isIdentifierHead(firstChar) {
            newID = String(firstChar)
        } else {
            newID = firstChar.isNumber ? "_\(firstChar)" : "_"
        }
        
        for char in id.dropFirst() {
            newID.append(isIdentifierBody(char) ? char : "_")
        }
        
        return LocalizationItem(
            id: newID,
            key: key,
            value: value,
            developerComments: developerComments,
            comment: comment)
    }
    
    private func isIdentifierHead(_ character: Character) -> Bool {
        return character.isLetter || character == "_"
    }
    
    private func isIdentifierBody(_ character: Character) -> Bool {
        return isIdentifierHead(character) || character.isNumber
    }
    
    public func hasCommentDirective(_ directive: String) -> Bool {
        return developerComments.contains(where: { $0.hasPrefix(directive) })
    }
}
