import SwiftUI
import Combine

struct TimerView: View {
    @State private var totalTime: Double = 1500.0
    @State private var selectedTime: Double = 1500.0
    @State private var remainingTime: Double = 1500.0
    @State private var timer: Timer? = nil
    @State private var isActive = false
    @State private var showMenu = false
    @State private var showSettings: Bool = false
    @State private var showTutorial: Bool = UserDefaults.standard.bool(forKey: "hasLaunchedBefore") == false
    
    let availableTimes: [Int] = [300, 1200, 1500, 1800, 2700, 3000, 3600, 5400] // In seconds

    var body: some View {
        ZStack {
            VStack {
                Spacer()  // Spacer added here to push the timer to the middle
                
                Text(timeString(time: Int(remainingTime)))
                    .font(.largeTitle)
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            showMenu.toggle()
                        }
                    }
                
                Button(action: startOrCancelTimer) {
                    Text(isActive ? "Cancel" : "Start")
                }
                .padding()
                
                Spacer()  // This Spacer will push the settings button to the bottom
                
                Button(action: {
                    showSettings.toggle()
                }) {
                    Image(systemName: "ellipsis")
                        .frame(width: 30, height: 30)
                        .font(.system(size: 30))
                }
                .padding(.bottom, 10)
            }
            .onDisappear {
                timer?.invalidate()
            }
            .padding()
            
            if showMenu {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }
                
                VStack(alignment: .center, spacing: 5) {
                    ForEach(availableTimes, id: \.self) { time in
                        Button(action: {
                            selectedTime = Double(time)
                            totalTime = selectedTime
                            remainingTime = totalTime
                            withAnimation {
                                showMenu = false
                            }
                        }) {
                            Text("\(time / 60) minutes")
                                .frame(minWidth: 100, alignment: .center)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .foregroundColor(.black)
                    }
                }
                .padding()
            }
            
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showTutorial, onDismiss: {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }) {
            TutorialView()
        }
    }

    func startOrCancelTimer() {
        if isActive {
            timer?.invalidate()
            remainingTime = totalTime
            isActive = false
        } else {
            isActive = true
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    timer?.invalidate()
                    isActive = false
                }
            }
        }
    }

    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
