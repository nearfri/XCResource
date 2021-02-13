import Foundation

struct FunctionItem: Equatable {
    var enumCase: Enumeration<String>.Case
    var parameters: [FunctionParameter]
}
