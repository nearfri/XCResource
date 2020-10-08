import Foundation
import SourceKittenFramework

class ActualKeyListFetcher: KeyListFetcher {
    func fetch(at url: URL, typeName: String) throws -> KeyList {
        let sourceCode = try String(contentsOf: url)
        let keys = try fetchKeys(fromSourceCode: sourceCode, typeName: typeName)
        return KeyList(filename: url.lastPathComponent, typeName: typeName, keys: keys)
    }
    
    func fetchKeys(fromSourceCode sourceCode: String, typeName: String) throws -> [String] {
        let fetcher = KeyListFetcherInternal(sourceCode: sourceCode, typeName: typeName)
        return try fetcher.fetchKeys()
    }
}

private class KeyListFetcherInternal {
    private let sourceCode: String
    private let typeName: String
    private var typeStructures: [SwiftStructure] = []
    private var keys: [String] = []
    
    init(sourceCode: String, typeName: String) {
        self.sourceCode = sourceCode
        self.typeName = typeName
    }
    
    func fetchKeys() throws -> [String] {
        try fetchTypeStructures()
        
        for typeStructure in typeStructures {
            fetchKeys(fromTypeStructure: typeStructure)
        }
        
        return keys
    }
    
    private func fetchTypeStructures() throws {
        let structureDictionary = try Structure(file: File(contents: sourceCode)).dictionary
        let fileStructure = SwiftStructure(dictionary: structureDictionary)
        
        typeStructures = (fileStructure.substructures ?? [])
            .filter({ $0.name == typeName })
            .filter({ ($0.$accessibility ?? .internal) >= .internal })
    }
    
    private func fetchKeys(fromTypeStructure typeStructure: SwiftStructure) {
        guard let memberStructures = typeStructure.substructures else { return }
        
        for i in 0..<memberStructures.count {
            let current = memberStructures[i]
            let next = i + 1 < memberStructures.count ? memberStructures[i + 1] : nil
            
            if let name = current.name, evaluateMemberStructure(current, next: next) {
                keys.append(name)
            }
        }
    }
    
    private func evaluateMemberStructure(_ member: SwiftStructure, next: SwiftStructure?) -> Bool {
        func typeNameOfMember() -> String? {
            if let name = member.typeName {
                return name
            }
            return next?.$kind == .exprCall ? next?.name : nil
        }
        
        return (member.$accessibility ?? .internal) >= .internal
            && member.$kind == .declVarStatic
            && typeNameOfMember() == typeName
    }
}
