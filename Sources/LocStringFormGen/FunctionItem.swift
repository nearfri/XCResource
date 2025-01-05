import Foundation
import LocSwiftCore

struct FunctionItem: Equatable, Sendable {
    var enumCase: Enumeration<String>.Case
    var parameters: [FunctionParameter]
}
