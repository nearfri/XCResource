import Foundation
import SourceKittenFramework

// Structure.dictionary는 그냥 JSON으로 출력하기엔 너무 많은 속성들을 담고 있다.
// 개발 중 몇 가지만 필터링해서 보고 싶을 때 사용한다.
extension Dictionary where Key == String, Value == SourceKitRepresentable {
    func filter<K>(includedSwiftKeys: K,
                   recursively: Bool
    ) -> Self where K: Collection, K.Element == SwiftKey {
        return filter(includedKeys: Set(includedSwiftKeys.map(\.rawValue)),
                      recursively: recursively)
    }
    
    func filter<K>(excludedSwiftKeys: K,
                   recursively: Bool
    ) -> Self where K: Collection, K.Element == SwiftKey {
        return filter(excludedKeys: Set(excludedSwiftKeys.map(\.rawValue)),
                      recursively: recursively)
    }
    
    func filter<K>(includedKeys: K,
                   recursively: Bool
    ) -> Self where K: Collection, K.Element == String {
        if !recursively {
            return filter({ includedKeys.contains($0.key) })
        }
        
        var result: [String: SourceKitRepresentable] = [:]
        
        for (key, value) in self where includedKeys.contains(key) {
            if let value = value as? [[String: SourceKitRepresentable]] {
                result[key] = value.map {
                    $0.filter(includedKeys: includedKeys, recursively: recursively)
                }
            } else if let value = value as? [String: SourceKitRepresentable] {
                result[key] = value.filter(includedKeys: includedKeys, recursively: recursively)
            } else {
                result[key] = value
            }
        }
        
        return result
    }
    
    func filter<K>(excludedKeys: K,
                   recursively: Bool
    ) -> Self where K: Collection, K.Element == String {
        if !recursively {
            return filter({ !excludedKeys.contains($0.key) })
        }
        
        var result: [String: SourceKitRepresentable] = [:]
        
        for (key, value) in self where !excludedKeys.contains(key) {
            if let value = value as? [[String: SourceKitRepresentable]] {
                result[key] = value.map {
                    $0.filter(excludedKeys: excludedKeys, recursively: recursively)
                }
            } else if let value = value as? [String: SourceKitRepresentable] {
                result[key] = value.filter(excludedKeys: excludedKeys, recursively: recursively)
            } else {
                result[key] = value
            }
        }
        
        return result
    }
}
