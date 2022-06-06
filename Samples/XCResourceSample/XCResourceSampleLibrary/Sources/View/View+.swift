import SwiftUI

extension View {
    func ifTrue(_ condition: Bool, @ViewBuilder then transform: (Self) -> Self) -> Self {
        if condition {
            return transform(self)
        } else {
            return self
        }
    }
    
    @ViewBuilder
    func ifTrue<V: View>(_ condition: Bool, @ViewBuilder then transform: (Self) -> V) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func ifLet<T, V: View>(_ value: T?, @ViewBuilder then transform: (Self, T) -> V) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}
