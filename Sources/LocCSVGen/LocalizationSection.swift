import Foundation
import LocStringCore

struct LocalizationSection: Equatable, Sendable {
    var language: LanguageID
    var items: [LocalizationItem] = []
}
