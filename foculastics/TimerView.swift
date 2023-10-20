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
    @State private var currentTask: String = ""
    @State private var showMessageView: Bool = false
    @State private var messageText: String = ""
    @State private var showNextButton: Bool = false
    @State private var showSettings: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var currentAnimation: AnimationType = .originalCube

    @Binding var showStopwatch: Bool

    let availableTimes: [Int] = [300, 900, 1500, 2700, 3000, 3600, 5400]

    var body: some View {
        ZStack {
            // Main view
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
                    if currentAnimation == .originalCube {
                        CubeView(rotationAngle: rotationAngle)
                            .frame(width: 100, height: 100)
                            .animation(.easeInOut(duration: 1.0), value: rotationAngle)
                    } else if currentAnimation == .colorful1Cube {
                        CubeView1(rotationAngle: rotationAngle)
                        .frame(width: 100, height: 100)
                        .animation(.easeInOut(duration: 1.0), value: rotationAngle)
                    } else if currentAnimation == .colorful2Cube {
                        CubeView2(rotationAngle: rotationAngle)
                        .frame(width: 100, height: 100)
                        .animation(.easeInOut(duration: 1.0), value: rotationAngle)
                    }
                }

                Spacer()
                
                TextField("Your task", text: $currentTask)
                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 30)

                Button(action: startOrStopTimer) {
                    Text(isTimerActive ? "Stop" : "Start")
                        .font(.system(size: 20))
                }
                .foregroundColor(Color.primary)
                .padding(.bottom, 30)

                Button(action: {
                    self.showStopwatch = true
                }) {
                    Image(systemName: "stopwatch.fill")
                        .font(.system(size: 24))
                        .frame(width: 30, height: 30)  // Set a fixed frame size
                }
                .foregroundColor(Color.primary)
                .padding(.bottom, 20)
                
                HStack(spacing: 10) {
                            Button(action: {
                                switch currentAnimation {
                                    case .originalCube:
                                        currentAnimation = .rainbowring
                                    case .colorful1Cube:
                                        currentAnimation = .originalCube
                                    case .colorful2Cube:
                                        currentAnimation = .colorful1Cube
                                    case .sphere:
                                        currentAnimation = .colorful2Cube
                                    case .rainbowring:
                                        currentAnimation = .sphere
                                }
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 24))
                            }
                            .padding(.trailing, 90)
                            .foregroundColor(Color.primary)

                            Button(action: {
                                showSettings.toggle()
                            }) {
                                Image(systemName: "ellipsis")
                                    .frame(width: 30, height: 30)
                                    .font(.system(size: 30))
                            }
                            .foregroundColor(Color.primary)

                            Button(action: {
                                switch currentAnimation {
                                    case .originalCube:
                                       currentAnimation = .colorful1Cube
                                   case .colorful1Cube:
                                       currentAnimation = .colorful2Cube
                                   case .colorful2Cube:
                                       currentAnimation = .sphere
                                   case .sphere:
                                       currentAnimation = .rainbowring
                                   case .rainbowring:
                                       currentAnimation = .originalCube
                                }
                            }) {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 24))
                            }
                            .padding(.leading, 90)
                            .foregroundColor(Color.primary)
                        }
                        .padding(.bottom, 5)
                        .padding(.top, 10)
            }
            .padding()
            .blur(radius: showMessageView || showMenu ? 5 : 0)

            // Dark background for whole screen
            if showMenu || showMessageView {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                            showMessageView = false
                        }
                    }
            }

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

            // Custom completion message view
            if showMessageView {
                VStack(spacing: 20) {
                    Text(messageText)
                        .font(.headline)
                        .foregroundColor(.black)
                    
                    if showNextButton {
                        Button("Next") {
                            showMessageView = false
                        }
                        .font(.system(size: 20))
                        .padding()
                        .frame(minWidth: 100, minHeight: 30)
                        .cornerRadius(8)
                    } else {
                        HStack(spacing: 30) {
                            Button("Yes") {
                                messageText = "Great job on completing \(currentTask). Keep the flow!"
                                showNextButton = true
                            }
                            .font(.system(size: 20))
                            .padding()
                            .frame(minWidth: 100, minHeight: 30)
                            .cornerRadius(8)
                            
                            Button("No") {
                                messageText = "Stay focused and try again. You can do it!"
                                showNextButton = true
                            }
                            .font(.system(size: 20))
                            .padding()
                            .frame(minWidth: 100, minHeight: 30)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .frame(width: 300, height: 150)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onAppear {
            requestNotificationPermission()
        }
        .onDisappear {
            timer?.invalidate()
        }
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("Okay")))
                }
    }

    func startOrStopTimer() {
        if isTimerActive {
            timer?.invalidate()
            let completedTask = currentTask  // Store the current task in a temporary variable
            resetTimer()
            messageText = "Did you complete \(completedTask)?"
            showMessageView = true
            showNextButton = false  // Reset to ensure we always start with the question
        } else {
            if currentTask.isEmpty {
                alertMessage = "Please enter a task before starting the time."
                showAlert = true
                return
            }
            isTimerActive = true
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if elapsedSeconds < Int(totalTime) {
                    elapsedSeconds += 1
                    rotationAngle += 45
                } else {
                    self.timer?.invalidate()
                    let completedTask = currentTask  // Store the current task in a temporary variable
                    resetTimer()
                    messageText = "Did you complete \(completedTask)?"
                    showMessageView = true
                    showNextButton = false  // Reset to ensure we always start with the question
                    sendNotification()
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
        content.title = "Timer Ended!"
        content.body = "Good job! Your timer for \(currentTask) has ended."
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }
    
    func resetTimer() {
        elapsedSeconds = 0
        rotationAngle = 0
        isTimerActive = false
        currentTask = ""
    }

}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(showStopwatch: .constant(false))
    }
}
