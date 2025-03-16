import Foundation
import RegexBuilder
import XCResourceUtil

extension LocalizationItem {
    public enum MemberDeclaration: Hashable, Sendable {
        case property(String)
        case method(String, [Parameter])
        
        public var id: String {
            switch self {
            case .property(let id), .method(let id, _):
                return id
            }
        }
    }
    
    public struct Parameter: Hashable, Sendable {
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
    
    public enum BundleDescription: Hashable, Sendable {
        case main
        case atURL(String)
        case forClass(String)
    }
}

public struct LocalizationItem: Hashable, Sendable, SettableByKeyPath {
    public var key: String
    public var defaultValue: String
    public var rawDefaultValue: String
    public var table: String?
    public var bundle: BundleDescription
    
    public var translationComment: String?
    public var developerComments: [String]
    public var memberDeclaration: MemberDeclaration
    
    public init(
        key: String,
        defaultValue: String,
        rawDefaultValue: String,
        table: String? = nil,
        bundle: BundleDescription = .main,
        translationComment: String? = nil,
        developerComments: [String] = [],
        memberDeclaration: MemberDeclaration
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.rawDefaultValue = rawDefaultValue
        self.table = table
        self.bundle = bundle
        self.translationComment = translationComment
        self.developerComments = developerComments
        self.memberDeclaration = memberDeclaration
    }
    
    public var documentComments: [String] {
        let formatter = CommentsFormatter.self
        
        var result = formatter.comments(from: defaultValue, type: .localizationValue)
        
        if let translationComment {
            result += [""]
            result += formatter.comments(from: translationComment, type: .translationComment)
        }
        
        return result
    }
    
    public var commentsSourceCode: String {
        let devComments = developerComments.map({ "// \($0)" })
        let docComments = documentComments.map({ $0.isEmpty ? "///" : "/// \($0)" })
        
        return (devComments + docComments).joined(separator: "\n") + "\n"
    }
}
