import Foundation

struct LocalizationSection: Equatable {
    var language: LanguageID
    var items: [LocalizationItem] = []
}
