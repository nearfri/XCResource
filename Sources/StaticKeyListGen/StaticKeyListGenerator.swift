import Foundation

protocol KeyListFetcher: AnyObject {
    func fetch(at url: URL, typeName: String) throws -> KeyList
}

protocol KeyListCodeGenerator: AnyObject {
    func generate(from keyList: KeyList, listName: String) -> String
}

extension StaticKeyListGenerator {
    public struct CodeRequest {
        public var sourceCodeURL: URL
        public var typeName: String
        public var listName: String = "allGeneratedKeys"
    
        public init(sourceCodeURL: URL, typeName: String, listName: String? = nil) {
            self.sourceCodeURL = sourceCodeURL
            self.typeName = typeName
            listName.map({ self.listName = $0 })
        }
    }
}

public class StaticKeyListGenerator {
    private let keyListFetcher: KeyListFetcher
    private let codeGenerator: KeyListCodeGenerator
    
    init(keyListFetcher: KeyListFetcher, codeGenerator: KeyListCodeGenerator) {
        self.keyListFetcher = keyListFetcher
        self.codeGenerator = codeGenerator
    }
    
    public convenience init() {
        self.init(keyListFetcher: ActualKeyListFetcher(),
                  codeGenerator: ActualKeyListCodeGenerator())
    }
    
    public func generate(for request: CodeRequest) throws -> String {
        let keyList = try keyListFetcher.fetch(at: request.sourceCodeURL,
                                               typeName: request.typeName)
        return codeGenerator.generate(from: keyList, listName: request.listName)
    }
}
