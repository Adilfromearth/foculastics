import SwiftUI

struct MainView: View {
    @State private var showStopwatch: Bool = false

    var body: some View {
        if showStopwatch {
            StopwatchView(showStopwatch: $showStopwatch)
        } else {
            TimerView(showStopwatch: $showStopwatch)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
