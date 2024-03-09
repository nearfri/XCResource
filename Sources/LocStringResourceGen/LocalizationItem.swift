import Foundation
import XCResourceUtil

extension LocalizationItem {
    public enum MemberDeclation: Hashable {
        case property(String)
        case method(String, [Parameter])
    }
    
    public struct Parameter: Hashable {
        public let firstName: String
        public let secondName: String?
        public let type: String
        public let defaultValue: String?
        
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

public struct LocalizationItem: Hashable, CopyableWithKeyPath {
    public let key: String
    public var defaultValue: String
    public var table: String?
    public var bundle: BundleDescription
    
    public var developerComments: [String]
    public var memberDeclation: MemberDeclation
    
    public init(
        key: String,
        defaultValue: String,
        table: String? = nil,
        bundle: BundleDescription = .main,
        developerComments: [String] = [],
        memberDeclation: MemberDeclation
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.table = table
        self.bundle = bundle
        self.developerComments = developerComments
        self.memberDeclation = memberDeclation
    }
    
    public var documentComments: [String] {
        let escaped = defaultValue.replacingOccurrences(of: #"\("#, with: #"\\("#)
        let splitted = escaped
            .replacingOccurrences(of: "\n", with: "\\\n")
            .split(separator: "\n", omittingEmptySubsequences: false)
        
        return splitted.map({ String($0) })
    }
    
    public var commentsSourceCode: String {
        let devComments = developerComments.map({ "// \($0)" })
        let docComments = documentComments.map({ "/// \($0)" })
        
        return (devComments + docComments).joined(separator: "\n") + "\n"
    }
}
