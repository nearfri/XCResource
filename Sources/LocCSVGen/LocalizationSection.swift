import Foundation
import LocStringCore

struct LocalizationSection: Equatable {
    var language: LanguageID
    var items: [LocalizationItem] = []
}
