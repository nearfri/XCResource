import Foundation

public struct Enumeration<RawValue: Equatable>: Equatable {
    public var name: String
    public var cases: [Case]
    
    public init(name: String, cases: [Case]) {
        self.name = name
        self.cases = cases
    }
}

extension Enumeration {
    public struct Case: Equatable {
        public var comments: [Comment]
        public var name: String
        public var rawValue: RawValue
        
        public init(comments: [Comment] = [], name: String, rawValue: RawValue) {
            self.comments = comments
            self.name = name
            self.rawValue = rawValue
        }
        
        public var joinedDocumentComment: String? {
            return comments.joinedDocumentText
        }
        
        public var developerComments: [String] {
            return comments.filter(\.isForDeveloper).map(\.text)
        }
        
        public func hasCommandName(_ commandName: String) -> Bool {
            return developerComments.contains(where: { $0.hasPrefix(commandName) })
        }
    }
}
