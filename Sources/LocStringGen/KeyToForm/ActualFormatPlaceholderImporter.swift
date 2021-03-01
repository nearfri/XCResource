import Foundation
import Strix
import StrixParsers

class ActualFormatPlaceholderImporter: FormatPlaceholderImporter {
    private let parser: Parser<[FormatElement]> = Parser.formatElements
    
    func `import`(from string: String) throws -> [FormatPlaceholder] {
        do {
            let formatElements = try parser.run(string)
            
            return formatElements.compactMap {
                guard case let .placeholder(placeholder, labels) = $0 else { return nil }
                return placeholder.toFormatPlaceholder(withLabels: labels)
            }
        } catch let error as Strix.RunError {
            let failureDescription = (error.failureReason ?? error.localizedDescription)
            
            throw IssueReportError(text: string,
                                   positionInText: error.position,
                                   failureDescription: failureDescription)
        }
    }
}

private extension StrixParsers.FormatPlaceholder {
    func toFormatPlaceholder(withLabels labels: [String]) -> FormatPlaceholder {
        return FormatPlaceholder(
            index: index,
            dynamicWidth: width?.toDynamicWidth(),
            dynamicPrecision: precision?.toDynamicPrecision(),
            valueType: formatPlaceholderType,
            labels: labels + (variableName.map({ [$0] }) ?? []))
    }
    
    private var formatPlaceholderType: Any.Type {
        switch conversion {
        case .object:
            return flags.contains(.hash) && variableName != nil ? Int.self : String.self
        default:
            return valueType
        }
    }
}

private extension StrixParsers.FormatPlaceholder.Width {
    func toDynamicWidth() -> FormatPlaceholder.DynamicWidth? {
        guard case let .dynamic(index) = self else { return nil }
        return FormatPlaceholder.DynamicWidth(index: index)
    }
    
    func toDynamicPrecision() -> FormatPlaceholder.DynamicPrecision? {
        return toDynamicWidth()
    }
}
