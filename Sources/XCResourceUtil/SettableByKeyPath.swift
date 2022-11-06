import Foundation

public protocol SettableByKeyPath {
    func setting<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self
}

extension SettableByKeyPath {
    public func setting<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
        var result = self
        result[keyPath: keyPath] = value
        return result
    }
}
