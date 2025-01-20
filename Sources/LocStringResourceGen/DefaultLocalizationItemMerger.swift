import Foundation

extension DefaultLocalizationItemMerger {
    struct CommentDirectives {
        var verbatim: String
    }
}

class DefaultLocalizationItemMerger: LocalizationItemMerger {
    private let commentDirectives: CommentDirectives
    
    init(commentDirectives: CommentDirectives) {
        self.commentDirectives = commentDirectives
    }
    
    func itemsByMerging(
        itemsInCatalog: [LocalizationItem],
        itemsInSourceCode: [LocalizationItem]
    ) -> [LocalizationItem] {
        let sourceCodeItemsByKey = itemsInSourceCode.reduce(into: [:]) { partialResult, item in
            partialResult[item.key] = item
        }
        
        return itemsInCatalog.map { itemInCatalog in
            guard let itemInSourceCode = sourceCodeItemsByKey[itemInCatalog.key] else {
                return itemInCatalog
            }
            
            var newItem = itemInCatalog
            
            if itemInSourceCode.hasCommentDirective(commentDirectives.verbatim) {
                newItem.defaultValue = newItem.rawDefaultValue
                newItem.memberDeclaration = .property(itemInSourceCode.memberDeclaration.id)
            } else if itemInSourceCode.hasResolvedParameterTypes(compatibleWith: itemInCatalog) {
                do {
                    try newItem.replaceInterpolations(with: itemInSourceCode)
                    newItem.memberDeclaration = itemInSourceCode.memberDeclaration
                } catch {
                    assertionFailure("\(error)")
                }
            }
            
            newItem.developerComments = itemInSourceCode.developerComments
            
            return newItem
        }
    }
}

private extension LocalizationItem {
    func hasCommentDirective(_ commentDirective: String) -> Bool {
        return developerComments.contains(commentDirective)
    }
    
    func hasResolvedParameterTypes(compatibleWith other: LocalizationItem) -> Bool {
        let lhs = resolvedParameterTypes
        let rhs = other.resolvedParameterTypes
        
        guard lhs.count == rhs.count else { return false }
        
        return zip(lhs, rhs).allSatisfy {
            switch ($0, $1) {
            case ("AttributedString", "String"):
                return true
            default:
                return $0 == $1
            }
        }
    }
}
