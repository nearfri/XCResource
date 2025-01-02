import Foundation

public enum MergeStrategy: Equatable, Sendable {
    case add(AddingMethod)
    case doNotAdd
    
    public enum AddingMethod: Equatable, Sendable {
        case comment
        case key
        case label(String)
    }
}
