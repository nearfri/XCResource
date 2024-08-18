import Foundation

public protocol SettableByKeyPath {
    func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self
    
    func with<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, _ value: T) -> Self
}

extension SettableByKeyPath {
    public func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
        var result = self
        result[keyPath: keyPath] = value
        return result
    }
    
    public func with<T>(_ keyPath: ReferenceWritableKeyPath<Self, T>, _ value: T) -> Self {
        self[keyPath: keyPath] = value
        return self
    }
}
