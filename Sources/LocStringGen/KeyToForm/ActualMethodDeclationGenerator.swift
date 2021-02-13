import Foundation

class ActualMethodDeclationGenerator: MethodDeclationGenerator {
    var maxColumns: Int = 100
    
    func generate(formTypeName: String, keyTypeName: String, items: [FunctionItem]) -> String {
        var result = ""
        
        result += "// MARK: - \(formTypeName) generated from \(keyTypeName)\n\n"
        result += "extension \(formTypeName) {\n"
        
        for (i, item) in items.enumerated() {
            result += i == 0 ? tab(1) : "\n\(tab(1))\n\(tab(1))"
            
            result += generate(formTypeName: formTypeName, keyTypeName: keyTypeName, item: item)
                .replacingOccurrences(of: "\n", with: "\n\(tab(1))")
        }
        
        result += "\n}"
        
        return result
    }
    
    func generate(formTypeName: String, keyTypeName: String, item: FunctionItem) -> String {
        return MethodGenerator(
            formTypeName: formTypeName,
            keyTypeName: keyTypeName,
            item: item,
            maxColumns: maxColumns - tabWidth
        )
        .generate()
    }
}

private let tabWidth: Int = 4

private func tab(_ count: Int) -> String {
    return String(repeating: " ", count: count * tabWidth)
}

private struct MethodGenerator {
    let formTypeName: String
    let keyTypeName: String
    let item: FunctionItem
    let maxColumns: Int
    
    func generate() -> String {
        var result = ""
        
        writeComments(to: &result)
        writeHeader(to: &result)
        writeBody(to: &result)
        
        return result
    }
    
    private func writeComments(to target: inout String) {
        for comment in item.enumCase.comments {
            switch comment {
            case .line, .block:
                break
            case .documentLine(let text):
                target += "/// \(text)\n"
            case .documentBlock(let text):
                target += """
                    /**
                     \(text.replacingOccurrences(of: "\n", with: "\n "))
                     */\n
                    """
            }
        }
    }
    
    private func writeHeader(to target: inout String) {
        let frontPart = "static func \(item.enumCase.identifier)("
        let backPart = ") -> \(formTypeName)"
        
        let paramParts = item.parameters.enumerated().map { index, parameter in
            return parameter.sourceCodeRepresentation(alternativeName: "_ param\(index + 1)")
        }
        let paramPartsInSingleLine = paramParts.joined(separator: ", ")
        
        let headerLength = [frontPart, paramPartsInSingleLine, backPart, " {"]
            .map(\.count)
            .reduce(0, +)
        
        if headerLength <= maxColumns {
            target += frontPart + paramPartsInSingleLine + backPart
        } else {
            let paramPartsInMultiline = paramParts.joined(separator: ",\n\(tab(1))")
            target += "\(frontPart)\n"
            target += "\(tab(1))\(paramPartsInMultiline)\n"
            target += backPart
        }
    }
    
    private func writeBody(to target: inout String) {
        target += " {\n"
        
        let frontPart = "\(tab(1))return \(formTypeName)"
        let keyPart = "key: \(keyTypeName).\(item.enumCase.identifier).rawValue"
        
        let argParts = item.parameters.enumerated().map { index, parameter in
            return parameter.localName.isEmpty ? "param\(index + 1)" : parameter.localName
        }
        let argPartsInSingleLine = "arguments: [\(argParts.joined(separator: ", "))]"
        
        let statementInSingleLine = "\(frontPart)(\(keyPart), \(argPartsInSingleLine))"
        if statementInSingleLine.count <= maxColumns {
            target += "\(statementInSingleLine)\n"
        } else {
            target += "\(frontPart)(\n"
            target += "\(tab(2))\(keyPart),\n"
            
            let backPart = "\(tab(2))\(argPartsInSingleLine))"
            if backPart.count <= maxColumns {
                target += "\(backPart)\n"
            } else {
                target += "\(tab(2))arguments: [\n"
                writeMultilineArguments(argParts, to: &target)
                target += "\(tab(2))])\n"
            }
        }
        
        target += "}"
    }
    
    private func writeMultilineArguments(_ arguments: [String], to target: inout String) {
        var currentLine = ""
        
        for argument in arguments {
            if currentLine.isEmpty {
                currentLine += "\(tab(3))\(argument)"
            } else if "\(currentLine), \(argument)".count < maxColumns {
                currentLine += ", \(argument)"
            } else {
                target += "\(currentLine),\n"
                currentLine = "\(tab(3))\(argument)"
            }
        }
        
        target += "\(currentLine)\n"
    }
}
