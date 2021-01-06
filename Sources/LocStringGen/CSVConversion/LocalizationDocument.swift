import Foundation

struct LocalizationDocument: Equatable {
    var header: [String] = []
    var records: [[String]] = []
}

private enum ColumnName {
    static let key = "Key"
    static let comment = "Comment"
}

extension LocalizationDocument {
    func validate() throws {
        if keyColumnIndex > header.count || header[keyColumnIndex] != ColumnName.key {
            throw LocalizationDocumentError.keyColumnDoesNotExist
        }
        
        if !records.allSatisfy({ $0.count == header.count }) {
            throw LocalizationDocumentError.inconsistentColumnCount
        }
    }
    
    private var keyColumnIndex: Int {
        return 0
    }
    
    private var commentColumnIndex: Int? {
        return header.count > 1 && header[1] == ColumnName.comment ? 1 : nil
    }
}

enum LocalizationDocumentError: Error {
    case keyColumnDoesNotExist
    case inconsistentColumnCount
}

// MARK: - Init with [LocalizationSection]

extension LocalizationDocument {
    init(sections: [LocalizationSection], formatter: LanguageFormatter) {
        header = [ColumnName.key, ColumnName.comment] + sections.map({ section in
            return formatter.string(from: section.language)
        })
        
        if sections.isEmpty { return }
        
        let fastSections = sections.map({ FastAccessibleSection(section: $0) })
        
        records = sections[0].items.reduce(into: [], { records, item in
            let values = fastSections.map({ $0[item.key]?.value ?? "" })
            let record: [String] = [item.key, item.comment ?? ""] + values
            records.append(record)
        })
    }
}

private struct FastAccessibleSection {
    var language: LanguageID
    var itemsByKey: [String: LocalizationItem]
    
    init(section: LocalizationSection) {
        language = section.language
        itemsByKey = section.items.reduce(into: [:], { items, item in
            items[item.key] = item
        })
    }
    
    subscript(key: String) -> LocalizationItem? {
        return itemsByKey[key]
    }
}

// MARK: - Convert to [LocalizationSection]

extension LocalizationDocument {
    func toSections() throws -> [LocalizationSection] {
        try validate()
        
        let commentColumnIndex = self.commentColumnIndex
        let firstLocalizationColumnIndex = (commentColumnIndex ?? keyColumnIndex) + 1
        guard firstLocalizationColumnIndex < header.count else { return [] }
        
        var sections = header[firstLocalizationColumnIndex...].map { language in
            LocalizationSection(language: LanguageID(language))
        }
        
        for record in records {
            let key = record[keyColumnIndex]
            let comment = commentColumnIndex.map({ record[$0] })
            for (i, value) in record[firstLocalizationColumnIndex...].enumerated() {
                let item = LocalizationItem(comment: comment, key: key, value: value)
                sections[i].items.append(item)
            }
        }
        
        return sections
    }
}
