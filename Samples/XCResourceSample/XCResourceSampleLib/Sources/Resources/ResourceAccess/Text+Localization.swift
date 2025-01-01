import Foundation
import SwiftUI

public extension Text {
    init(key: StringKey) {
        self.init(LocalizedStringKey(key.rawValue), bundle: .module)
    }
    
    // It doesn't support EnvironmentValues.locale because it uses NSLocalizedString.
    init(form: StringForm) {
        self.init(String.formatted(form))
    }
}
