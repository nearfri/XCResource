import Foundation
import SwiftUI

public extension Label where Title == Text, Icon == Image {
    init<S: StringProtocol>(_ title: S, imageKey: ImageKey) {
        self.init {
            Text(title)
        } icon: {
            Image(key: imageKey)
        }
    }
    
    init(title: LocalizedStringResource, imageKey: ImageKey) {
        self.init {
            Text(title)
        } icon: {
            Image(key: imageKey)
        }
    }
}
