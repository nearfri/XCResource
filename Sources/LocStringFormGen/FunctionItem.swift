import Foundation
import LocSwiftCore

struct FunctionItem: Equatable {
    var enumCase: Enumeration<String>.Case
    var parameters: [FunctionParameter]
}
