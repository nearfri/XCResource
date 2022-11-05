import Foundation

class DefaultLocalizationDifferenceCalculator: LocalizationDifferenceCalculator {
    func calculate(
        targetItems: [LocalizationItem],
        baseItems: [LocalizationItem]
    ) -> LocalizationDifference {
        return CalculatorInternal(targetItems: targetItems, baseItems: baseItems).calculate()
    }
}

private class CalculatorInternal {
    private let targetItems: [LocalizationItem]
    private let baseItems: [LocalizationItem]
    
    private var difference: CollectionDifference<String> = .init([])!
    private var targetItemsByKey: [String: LocalizationItem] = [:]
    private var baseItemsByKey: [String: LocalizationItem] = [:]
    
    private var insertions: [(index: Int, item: LocalizationItem)] = []
    private var removals: Set<LocalizationItem.ID> = []
    private var modifications: [LocalizationItem.ID: LocalizationItem] = [:]
    
    init(targetItems: [LocalizationItem], baseItems: [LocalizationItem]) {
        self.targetItems = targetItems
        self.baseItems = baseItems
    }
    
    func calculate() -> LocalizationDifference {
        calculateDifference()
        
        calculateInsertions()
        
        calculateRemovals()
        
        calculateModifications()
        
        return LocalizationDifference(
            insertions: insertions,
            removals: removals,
            modifications: modifications)
    }
    
    private func calculateDifference() {
        let targetKeys = targetItems.map { $0.key }
        let baseKeys = baseItems.map { $0.key }
        
        targetItemsByKey = Dictionary(uniqueKeysWithValues: zip(targetKeys, targetItems))
        baseItemsByKey = Dictionary(uniqueKeysWithValues: zip(baseKeys, baseItems))
        
        difference = targetKeys.difference(from: baseKeys)
        difference = difference.inferringMoves()
    }
    
    private func calculateInsertions() {
        insertions = difference.insertions.reduce(into: []) { partialResult, change in
            guard case let .insert(index, key, association) = change, association == nil,
                  var targetItem = targetItemsByKey[key]
            else { return }
            
            targetItem.comment = targetItem.comment
            partialResult.append((index, targetItem))
        }
    }
    
    private func calculateRemovals() {
        removals = difference.removals.reduce(into: []) { partialResult, change in
            guard case let .remove(_, key, association) = change, association == nil,
                  let baseItem = baseItemsByKey[key]
            else { return }
            
            partialResult.insert(baseItem.id)
        }
    }
    
    private func calculateModifications() {
        modifications = baseItemsByKey.reduce(into: [:]) { partialResult, element in
            var baseItem = element.value
            guard let targetItem = targetItemsByKey[baseItem.key] else { return }
            
            if baseItem.comment != targetItem.comment {
                baseItem.comment = targetItem.comment
                partialResult[baseItem.id] = baseItem
            }
        }
    }
}
