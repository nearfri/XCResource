import Foundation
import LocStringCore
import OrderedCollections

class DefaultLocalizationDifferenceCalculator: LocalizationDifferenceCalculator {
    func calculate(
        targetItems: [LocalizationItem],
        baseItems: [LocalizationItem],
        allBaseItems: [LocalizationItem]
    ) -> LocalizationDifference {
        let calculator = CalculatorInternal(
            targetItems: targetItems,
            baseItems: baseItems,
            allBaseItems: allBaseItems)
        
        return calculator.calculate()
    }
}

private class CalculatorInternal {
    private let targetItems: [LocalizationItem]
    private let baseItems: [LocalizationItem]
    
    private let targetItemsByKey: [String: LocalizationItem]
    private var allBaseItemKeys: OrderedSet<String>
    
    private var insertions: [(index: Int, item: LocalizationItem)] = []
    private var removals: Set<LocalizationItem.ID> = []
    private var modifications: [LocalizationItem.ID: LocalizationItem] = [:]
    
    init(targetItems: [LocalizationItem],
         baseItems: [LocalizationItem],
         allBaseItems: [LocalizationItem]
    ) {
        self.targetItems = targetItems
        self.baseItems = baseItems
        
        self.targetItemsByKey = Self.makeItemsByKey(items: targetItems)
        self.allBaseItemKeys = OrderedSet(allBaseItems.map(\.key))
    }
    
    private static func makeItemsByKey(items: [LocalizationItem]) -> [String: LocalizationItem] {
        return Dictionary(uniqueKeysWithValues: zip(items.map(\.key), items))
    }
    
    func calculate() -> LocalizationDifference {
        calculateModifications()
        
        calculateRemovals()
        
        calculateInsertions()
        
        return LocalizationDifference(
            insertions: insertions,
            removals: removals,
            modifications: modifications)
    }
    
    private func calculateModifications() {
        modifications = baseItems.reduce(into: [:]) { partialResult, baseItem in
            guard let targetItem = targetItemsByKey[baseItem.key] else { return }
            
            if baseItem.comment != targetItem.comment {
                partialResult[baseItem.id] = baseItem.setting(\.comment, targetItem.comment)
            }
        }
    }
    
    private func calculateRemovals() {
        for baseItem in baseItems {
            guard targetItemsByKey[baseItem.key] == nil else { continue }
            
            allBaseItemKeys.remove(baseItem.key)
            removals.insert(baseItem.id)
        }
    }
    
    private func calculateInsertions() {
        for (index, targetItem) in targetItems.enumerated() {
            if allBaseItemKeys.contains(targetItem.key) { continue }
            
            let newItemIndex = insertionIndexForTargetItem(at: index)
            
            allBaseItemKeys.insert(targetItem.key, at: newItemIndex)
            insertions.append((newItemIndex, targetItem))
        }
    }
    
    private func insertionIndexForTargetItem(at index: Int) -> Int {
        let prevTargetItem = index > 0 ? targetItems[index - 1] : nil
        let prevBaseIndex = prevTargetItem.flatMap({ allBaseItemKeys.firstIndex(of: $0.key) })
        
        let (nextBaseIndex, nextTargetItem): (Int?, LocalizationItem?) = {
            for i in (index + 1)..<targetItems.count {
                if let baseIndex = allBaseItemKeys.firstIndex(of: targetItems[i].key) {
                    return (baseIndex, targetItems[i])
                }
            }
            return (nil, nil)
        }()
        
        switch (prevBaseIndex, nextBaseIndex) {
        case let (prevIndex?, nextIndex?):
            let prevCommonPrefix = targetItems[index].key.commonPrefix(with: prevTargetItem!.key)
            let nextCommonPrefix = targetItems[index].key.commonPrefix(with: nextTargetItem!.key)
            return prevCommonPrefix.count > nextCommonPrefix.count ? prevIndex + 1 : nextIndex
        case let (prevIndex?, nil):
            return prevIndex + 1
        case let (nil, nextIndex?):
            return nextIndex
        case (nil, nil):
            return 0
        }
    }
}
