import Foundation

class ActualKeyListCodeGenerator: KeyListCodeGenerator {
    func generate(from keyList: KeyList, listName: String) -> String {
        var result = ""
        
        print("""
            extension \(keyList.typeName) {
                static let \(listName): [\(keyList.typeName)] = [
                    // MARK: \(keyList.filename)
            """, to: &result)
        
        for key in keyList.keys {
            print("        .\(key),", to: &result)
        }
        
        print("    ]", to: &result)
        print("}", terminator: "", to: &result)
        
        return result
    }
}
