import Foundation

public enum MergeStrategy: Equatable {
    case add(AddingMethod)
    case doNotAdd
    
    public enum AddingMethod: Equatable {
        case comment
        case key
        case label(String)
    }
}
