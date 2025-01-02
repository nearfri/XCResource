import Foundation

struct FunctionParameter: Equatable, Sendable {
    var externalName: String
    var localName: String
    var type: Any.Type
    
    static func == (lhs: FunctionParameter, rhs: FunctionParameter) -> Bool {
        return lhs.externalName == rhs.externalName &&
        lhs.localName == rhs.localName &&
        lhs.type == rhs.type
    }
    
    func sourceCodeRepresentation(alternativeName: String) -> String {
        if localName.isEmpty {
            return "\(alternativeName): \(type)"
        }
        
        if externalName.isEmpty || externalName == localName {
            return "\(localName): \(type)"
        }
        
        return "\(externalName) \(localName): \(type)"
    }
}
