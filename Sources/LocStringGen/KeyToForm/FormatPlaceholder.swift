import Foundation

struct FormatPlaceholder: Equatable {
    var index: Index?
    var dynamicWidth: DynamicWidth?
    var dynamicPrecision: DynamicPrecision?
    var valueType: Any.Type
    var labels: [String] = []
    
    static func == (lhs: FormatPlaceholder, rhs: FormatPlaceholder) -> Bool {
        return lhs.index == rhs.index
            && lhs.dynamicWidth == rhs.dynamicWidth
            && lhs.dynamicPrecision == rhs.dynamicPrecision
            && lhs.valueType == rhs.valueType
            && lhs.labels == rhs.labels
    }
}

extension FormatPlaceholder {
    typealias Index = Int
    
    struct DynamicWidth: Equatable {
        var index: Index?
    }
    
    typealias DynamicPrecision = DynamicWidth
}

extension Array where Element == FormatPlaceholder {
    func toFunctionParameters() throws -> [FunctionParameter] {
        var converter = PlaceholderToParameterConverter(placeholders: self)
        return try converter.convert()
    }
}

private struct PlaceholderToParameterConverter {
    private typealias Index = FormatPlaceholder.Index
    
    let placeholders: [FormatPlaceholder]
    private var unsortedParameters: [(index: Index?, parameter: FunctionParameter)] = []
    
    init(placeholders: [FormatPlaceholder]) {
        self.placeholders = placeholders
    }
    
    mutating func convert() throws -> [FunctionParameter] {
        generateUnsortedParamters()
        
        try validateUnsortedParamters()
        
        guard areParametersIndexed else {
            return unsortedParameters.map(\.parameter)
        }
        
        return sortedParameters()
    }
    
    private mutating func generateUnsortedParamters() {
        func appendParameter(withIndex index: Int?, label: String, type: Any.Type) {
            unsortedParameters.append((index, makeParameter(label: label, type: type)))
        }
        
        for placeholder in placeholders {
            var labelIterator = placeholder.labels.makeIterator()
            
            if let width = placeholder.dynamicWidth {
                let label = labelIterator.next() ?? ""
                appendParameter(withIndex: width.index, label: label, type: Int.self)
            }
            
            if let precision = placeholder.dynamicPrecision {
                let label = labelIterator.next() ?? ""
                appendParameter(withIndex: precision.index, label: label, type: Int.self)
            }
            
            let label = labelIterator.next() ?? ""
            appendParameter(withIndex: placeholder.index, label: label, type: placeholder.valueType)
        }
    }
    
    private func makeParameter(label: String, type: Any.Type) -> FunctionParameter {
        let names = splitLabel(label)
        
        return FunctionParameter(
            externalName: names.externalName,
            localName: names.localName,
            type: type)
    }
    
    private func splitLabel(_ label: String) -> (externalName: String, localName: String) {
        let names = label
            .split(separator: " ")
            .map({ $0.trimmingCharacters(in: .whitespaces) })
        
        switch names.count {
        case 0:
            return ("", "")
        case 1:
            return ("", names[0])
        default:
            return (names[0], names[1])
        }
    }
    
    private func validateUnsortedParamters() throws {
        let indices = unsortedParameters.compactMap({ $0.index })
        
        if indices.isEmpty {
            return
        }
        
        guard indices.count == unsortedParameters.count else {
            throw FormatPlaceholderError("Mixing indexed and non-indexed parameters is invalid.")
        }
        
        let actualIndexSet = Set(indices)
        let expectedIndexSet = Set(1...actualIndexSet.count)
        let missingIndexSet = expectedIndexSet.subtracting(actualIndexSet)
        
        guard missingIndexSet.isEmpty else {
            if missingIndexSet.count == 1 {
                throw FormatPlaceholderError("Index \(missingIndexSet.first!) is missing.")
            } else {
                throw FormatPlaceholderError("Indices \(missingIndexSet.sorted()) are missing.")
            }
        }
    }
    
    private var areParametersIndexed: Bool {
        return unsortedParameters.first?.index != nil
    }
    
    private func sortedParameters() -> [FunctionParameter] {
        let parametersByIndex = Dictionary(unsortedParameters.map({ ($0.index!, $0.parameter) }),
                                           uniquingKeysWith: { $1.localName.isEmpty ? $0 : $1 })
        return parametersByIndex.sorted(by: { $0.key < $1.key }).map(\.value)
    }
}

struct FormatPlaceholderError: LocalizedError {
    var errorDescription: String?
    
    init(_ errorDescription: String?) {
        self.errorDescription = errorDescription
    }
}
