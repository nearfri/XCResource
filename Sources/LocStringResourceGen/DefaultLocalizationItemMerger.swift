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
            } else {
                newItem.memberDeclaration.id = itemInSourceCode.memberDeclaration.id
            }
            
            newItem.developerComments = itemInSourceCode.developerComments
            newItem.attributes = itemInSourceCode.attributes
            
            return newItem
        }
    }
}

private extension LocalizationItem {
    func hasCommentDirective(_ commentDirective: String) -> Bool {
        return developerComments.contains(commentDirective)
    }
    
    func hasResolvedParameterTypes(compatibleWith other: LocalizationItem) -> Bool {
        let typesInSourceCode = resolvedParameterTypes
        let typesInCatalog = other.resolvedParameterTypes
        
        guard typesInSourceCode.count == typesInCatalog.count else { return false }
        
        let compatibleTypes: [String: Set<String>] = [
            "Float": ["Double"],
            "String": [
                "AttributedString",
                // CustomLocalizedStringResourceConvertible types
                "AppIntentError",
                "CLPlacemark",
                "LocalizedStringResource",
                "ManagedAppDistributionError",
            ],
        ]
        
        return zip(typesInCatalog, typesInSourceCode).allSatisfy { typeInCatalog, typeInCode in
            if typeInCatalog == typeInCode {
                return true
            }
            return compatibleTypes[typeInCatalog]?.contains(typeInCode) ?? false
        }
    }
}
