import Foundation

class ActualTypeDeclarationGenerator: TypeDeclarationGenerator {
    func generate(formTypeName: String) -> String {
        return """
            struct \(formTypeName) {
                var key: String
                var arguments: [CVarArg]
            }
            """
    }
}
