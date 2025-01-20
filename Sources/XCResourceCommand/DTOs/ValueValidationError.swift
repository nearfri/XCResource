import Foundation

struct ValueValidationError: LocalizedError {
    var key: String
    var value: String
    var valueDescription: String
    
    var errorDescription: String? {
        return "The value '\(value)' is invalid for '\(key) <\(valueDescription)>'"
    }
}
