import Foundation
import RegexBuilder
import XCResourceUtil

extension LocalizationItem {
    public enum MemberDeclation: Hashable {
        case property(String)
        case method(String, [Parameter])
        
        public var id: String {
            switch self {
            case .property(let id), .method(let id, _):
                return id
            }
        }
        
        public func fixingID() -> MemberDeclation {
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
            
            switch self {
            case .property:
                return .property(newID)
            case .method(_, let parameters):
                return .method(newID, parameters)
            }
        }
        
        private func isIdentifierHead(_ character: Character) -> Bool {
            return character.isLetter || character == "_"
        }
        
        private func isIdentifierBody(_ character: Character) -> Bool {
            return isIdentifierHead(character) || character.isNumber
        }
    }
    
    public struct Parameter: Hashable {
        public var firstName: String
        public var secondName: String?
        public var type: String
        public var defaultValue: String?
        
        public init(
            firstName: String,
            secondName: String? = nil,
            type: String,
            defaultValue: String? = nil
        ) {
            self.firstName = firstName
            self.secondName = secondName
            self.type = type
            self.defaultValue = defaultValue
        }
    }
    
    public enum BundleDescription: Hashable {
        case main
        case atURL(String)
        case forClass(String)
    }
}

public struct LocalizationItem: Hashable, SettableByKeyPath {
    public var key: String
    public var defaultValue: String
    public var rawDefaultValue: String
    public var table: String?
    public var bundle: BundleDescription
    
    public var developerComments: [String]
    public var memberDeclation: MemberDeclation
    
    public init(
        key: String,
        defaultValue: String,
        rawDefaultValue: String,
        table: String? = nil,
        bundle: BundleDescription = .main,
        developerComments: [String] = [],
        memberDeclation: MemberDeclation
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.rawDefaultValue = rawDefaultValue
        self.table = table
        self.bundle = bundle
        self.developerComments = developerComments
        self.memberDeclation = memberDeclation
    }
    
    public var documentComments: [String] {
        return CommentsFormatter.comments(from: defaultValue)
    }
    
    public var commentsSourceCode: String {
        let devComments = developerComments.map({ "// \($0)" })
        let docComments = documentComments.map({ "/// \($0)" })
        
        return (devComments + docComments).joined(separator: "\n") + "\n"
    }
}
