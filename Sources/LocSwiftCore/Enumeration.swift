import Foundation

public struct Enumeration<RawValue: Equatable>: Equatable {
    public var identifier: String
    public var cases: [Case]
    
    public init(identifier: String, cases: [Case]) {
        self.identifier = identifier
        self.cases = cases
    }
}

extension Enumeration {
    public struct Case: Equatable {
        public var comments: [Comment]
        public var identifier: String
        public var rawValue: RawValue
        
        public init(comments: [Comment] = [], identifier: String, rawValue: RawValue) {
            self.comments = comments
            self.identifier = identifier
            self.rawValue = rawValue
        }
        
        public var joinedDocumentComment: String? {
            return comments.joinedDocumentText
        }
        
        public func hasCommandName(_ commandName: String) -> Bool {
            return comments
                .filter(\.isForDeveloper)
                .map(\.text)
                .contains(where: { $0.hasPrefix(commandName) })
        }
    }
}
