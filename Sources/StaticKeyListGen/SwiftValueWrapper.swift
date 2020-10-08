import Foundation

@propertyWrapper
struct SwiftValueWrapper<Wrapped, Projected>: Codable
where Wrapped: Codable, Projected: RawRepresentable, Wrapped == Projected.RawValue {
    var wrappedValue: Wrapped?
    
    var projectedValue: Projected? {
        return wrappedValue.flatMap({ Projected(rawValue: $0) })
    }
}
