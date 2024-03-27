import Foundation

public protocol CopyableWithKeyPath {
    func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self
}

extension CopyableWithKeyPath {
    public func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
        var result = self
        result[keyPath: keyPath] = value
        return result
    }
}
