import SwiftUI

@main
struct foculasticsApp: App {
    let persistenceController = PersistenceController.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State private var showStopwatch: Bool = false

    var body: some Scene {
        WindowGroup {
            if showStopwatch {
                StopwatchView(showStopwatch: $showStopwatch)
                    .accentColor(.black) // Setting accent color to black
            } else {
                TimerView(showStopwatch: $showStopwatch)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .accentColor(.black) // Setting accent color to black
            }
        }
    }
}
