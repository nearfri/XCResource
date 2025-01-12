import SwiftUI
import View

@main
struct XCResourceExampleApp: App {
    @NSApplicationDelegateAdaptor
    private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 300, minHeight: 200)
        }
    }
}
