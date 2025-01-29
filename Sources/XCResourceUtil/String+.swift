import Foundation
import RegexBuilder

extension String {
    public func toIdentifier() -> String {
        return toIdentifier(isForType: false)
    }
    
    public func toTypeIdentifier() -> String {
        return toIdentifier(isForType: true)
    }
    
    private func toIdentifier(isForType: Bool) -> String {
        let wordSeparator = CharacterClass.word.subtracting(.anyOf("_")).inverted
        let components = split(separator: wordSeparator).map({ String($0) })
        
        if components.isEmpty {
            return "_"
        }
        
        let casedComponents = if isForType {
            components.map({ $0.pascalCased() })
        } else {
            [components[0].camelCased()] + components.dropFirst().map({ $0.pascalCased() })
        }
        
        let identifier = casedComponents.joined()
        
        return identifier.first?.isNumber == true ? "_" + identifier : identifier
    }
    
    public func camelCased() -> String {
        var result = ""
        
        var allowsUppercase = false
        for index in indices {
            let character = self[index]
            if index == startIndex {
                result += character.lowercased()
            } else if character.isLowercase {
                result.append(character)
                allowsUppercase = true
            } else {
                let nextIndex = self.index(after: index)
                let isNextLowercase = nextIndex < endIndex ? self[nextIndex].isLowercase : false
                let hasNextNext = nextIndex < endIndex && self.index(after: nextIndex) < endIndex
                let isBeginningOfWord = isNextLowercase && hasNextNext
                
                if allowsUppercase || isBeginningOfWord {
                    result.append(character)
                } else {
                    result += character.lowercased()
                }
            }
        }
        
        return result
    }
    
    public func pascalCased() -> String {
        return (first?.uppercased() ?? "") + dropFirst()
    }
    
    public func latinCased() -> String {
        struct Word {
            var string: String
            let isLatin: Bool
            
            func toLatin() -> String {
                return string.applyingTransform(.toLatin, reverse: false) ?? string
            }
        }
        
        if self == applyingTransform(.toLatin, reverse: false) {
            return self
        }
        
        let words: [Word] = map({ String($0) }).reduce(into: []) { partialResult, char in
            let latin = char.applyingTransform(.toLatin, reverse: false) ?? char
            let isLatin = char == latin
            if partialResult.last?.isLatin == isLatin {
                partialResult[partialResult.count - 1].string += char
            } else {
                partialResult.append(Word(string: char, isLatin: isLatin))
            }
        }
        
        return words.reduce(into: "") { partialResult, word in
            if partialResult.isEmpty {
                partialResult.append(word.toLatin())
            } else {
                partialResult.append(word.toLatin().pascalCased())
            }
        }
    }
    
    public func appendingPathComponent(_ str: some StringProtocol) -> String {
        if isEmpty { return String(str) }
        if str.isEmpty { return self }
        
        switch (hasSuffix("/"), str.hasPrefix("/")) {
        case (false, false):
            return self + "/" + str
        case (true, false), (false, true):
            return self + str
        case (true, true):
            return self + str.dropFirst()
        }
    }
    
    public var deletingLastPathComponent: String {
        let truncatedPath = self        // /tmp/scratch.tiff/
            .reversed()                 // /ffit.hctarcs/pmt/
            .drop(while: { $0 == "/" }) // ffit.hctarcs/pmt/
            .drop(while: { $0 != "/" }) // /pmt/
            .dropFirst()                // pmt/
            .reversed()                 // /tmp
        
        if truncatedPath.isEmpty && hasPrefix("/") {
            return "/"
        }
        return String(truncatedPath)
    }
    
    public var lastPathComponent: String {
        let lastComponent = self            // /tmp/scratch.tiff/
            .reversed()                     // /ffit.hctarcs/pmt/
            .drop(while: { $0 == "/" })     // ffit.hctarcs/pmt/
            .prefix(while: { $0 != "/" })   // ffit.hctarcs
            .reversed()                     // scratch.tiff
        
        if lastComponent.isEmpty && hasPrefix("/") {
            return "/"
        }
        return String(lastComponent)
    }
}
