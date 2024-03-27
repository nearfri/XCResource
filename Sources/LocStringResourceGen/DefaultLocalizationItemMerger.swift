import Foundation

extension DefaultLocalizationItemMerger {
    struct CommentCommandNames {
        var useRaw: String
    }
}

class DefaultLocalizationItemMerger: LocalizationItemMerger {
    private let commentCommandNames: CommentCommandNames
    
    init(commentCommandNames: CommentCommandNames) {
        self.commentCommandNames = commentCommandNames
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
            
            if itemInSourceCode.hasCommentCommand(named: commentCommandNames.useRaw) {
                newItem.defaultValue = newItem.rawDefaultValue
                newItem.memberDeclation = .property(itemInSourceCode.memberDeclation.id)
            } else if itemInSourceCode.hasResolvedParameterTypes(equalTo: itemInCatalog) {
                do {
                    try newItem.replaceInterpolations(with: itemInSourceCode)
                    newItem.memberDeclation = itemInSourceCode.memberDeclation
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
    func hasCommentCommand(named name: String) -> Bool {
        return developerComments.contains(name)
    }
    
    func hasResolvedParameterTypes(equalTo other: LocalizationItem) -> Bool {
        return resolvedParameterTypes == other.resolvedParameterTypes
    }
}
