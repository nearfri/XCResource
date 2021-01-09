import Foundation

struct LocalizationTable: Equatable {
    var header: [String] = []
    var records: [[String]] = []
}

private enum ColumnName {
    static let key = "Key"
    static let comment = "Comment"
}

extension LocalizationTable {
    func validate() throws {
        if keyColumnIndex > header.count || header[keyColumnIndex] != ColumnName.key {
            throw LocalizationTableError.keyColumnDoesNotExist
        }
        
        if !records.allSatisfy({ $0.count == header.count }) {
            throw LocalizationTableError.inconsistentColumnCount
        }
    }
    
    private var keyColumnIndex: Int {
        return 0
    }
    
    private var commentColumnIndex: Int? {
        return header.count > 1 && header[1] == ColumnName.comment ? 1 : nil
    }
}

enum LocalizationTableError: Error {
    case keyColumnDoesNotExist
    case inconsistentColumnCount
    case invalidLanguageString(String)
}

// MARK: - Init with [LocalizationSection]

extension LocalizationTable {
    init(sections: [LocalizationSection], languageFormatter: LanguageFormatter) {
        header = [ColumnName.key, ColumnName.comment] + sections.map({ section in
            return languageFormatter.string(from: section.language)
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

extension LocalizationTable {
    func toSections(languageFormatter: LanguageFormatter,
                    includeEmptyFields: Bool = false
    ) throws -> [LocalizationSection] {
        try validate()
        
        let commentColumnIndex = self.commentColumnIndex
        let firstValueColumnIndex = (commentColumnIndex ?? keyColumnIndex) + 1
        guard firstValueColumnIndex < header.count else { return [] }
        
        var sections: [LocalizationSection] = try header[firstValueColumnIndex...].map { string in
            guard let language = languageFormatter.language(from: string) else {
                throw LocalizationTableError.invalidLanguageString(string)
            }
            return LocalizationSection(language: language)
        }
        
        for record in records {
            let key = record[keyColumnIndex]
            let comment = commentColumnIndex.map({ record[$0] })
            for (i, value) in record[firstValueColumnIndex...].enumerated() {
                if value.isEmpty && !includeEmptyFields { continue }
                let item = LocalizationItem(comment: comment, key: key, value: value)
                sections[i].items.append(item)
            }
        }
        
        return sections
    }
}
