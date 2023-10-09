import SwiftUI
import Combine
import UserNotifications

struct TimerView: View {
    @State private var totalTime: Double = 1500.0
    @State private var elapsedSeconds: Int = 0
    @State private var rotationAngle: Double = 0
    @State private var timer: Timer? = nil
    @State private var isTimerActive = false
    @State private var showMenu = false
    @State private var showSettings: Bool = false
    @State private var showTutorial: Bool = UserDefaults.standard.bool(forKey: "hasLaunchedBefore") == false
    @State private var startTime: Date? = nil
    
    @Binding var showStopwatch: Bool

    let availableTimes: [Int] = [300, 900, 1500, 2700, 3000, 3600, 5400]

    var body: some View {
        ZStack {
               if showMenu {
                   Color.black.opacity(0.4)
                       .edgesIgnoringSafeArea(.all)
                       .onTapGesture {
                           withAnimation {
                               showMenu = false
                           }
                       }
               }

               VStack {
                   Text(timeString(time: Int(totalTime) - elapsedSeconds))
                       .font(.largeTitle)
                       .padding(.top, 40)
                       .onTapGesture {
                           withAnimation {
                               showMenu.toggle()
                           }
                       }

                   Spacer()

                   ZStack {
                       CubeView(rotationAngle: rotationAngle)
                           .frame(width: 100, height: 100)
                           .offset(x: 0, y: 20)
                           .animation(.easeInOut(duration: 1.0), value: rotationAngle)
                           .onTapGesture {
                                       withAnimation {
                                           showMenu.toggle()
                                       }
                                   }
                   }

                Spacer()
                   
                   
                Button(action: startOrStopTimer) {
                    Text(isTimerActive ? "Stop" : "Start")
                }
                .foregroundColor(Color.primary)
                .padding(.bottom, 30)

                Button(action: {
                    self.showStopwatch = true
                }) {
                    Image(systemName: "stopwatch.fill")
                        .font(.system(size: 24))
                }
                .foregroundColor(Color.primary)
                .padding(.bottom, 20)

                Button(action: {
                    showSettings.toggle()
                }) {
                    Image(systemName: "ellipsis")
                        .frame(width: 30, height: 30)
                        .font(.system(size: 30))
                }
                .foregroundColor(Color.primary)
                .padding(.bottom, 10)
            }
            .padding()

            // Menu
            if showMenu {
                VStack(alignment: .center, spacing: 5) {
                    ForEach(availableTimes, id: \.self) { time in
                        Button(action: {
                            totalTime = Double(time)
                            elapsedSeconds = 0
                            rotationAngle = 0
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
        .onAppear {
            requestNotificationPermission()
        }
        .onDisappear {
            timer?.invalidate()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showTutorial, onDismiss: {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }) {
            TutorialView(showTutorial: $showTutorial)
        }
    }

    func startOrStopTimer() {
        if isTimerActive {
            timer?.invalidate()
            elapsedSeconds = 0
            rotationAngle = 0
            isTimerActive = false
            startTime = nil
        } else {
            isTimerActive = true
            startTime = Date() // Store the start time
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if let startTime = startTime {
                    let currentElapsed = Int(Date().timeIntervalSince(startTime))
                    if currentElapsed < Int(totalTime) {
                        elapsedSeconds = currentElapsed
                        rotationAngle += 45
                    } else {
                        timer?.invalidate()
                        isTimerActive = false
                        sendNotification()  // Send the notification
                    }
                }
            }
        }
    }

    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Handle the authorization request result.
        }
    }

    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished"
        content.body = "Good job, the timer has ended!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(showStopwatch: .constant(false))
    }
}
