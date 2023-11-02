import SwiftUI

struct StopwatchView: View {
    @Binding var showStopwatch: Bool
    @State private var elapsedSeconds: Int = 0
    @State private var stopwatchTimer: Timer? = nil
    @State private var isStopwatchActive = false
    @State private var rotationAngle: Double = 0 // Angle for cube rotation
    @State private var startTime: Date? = nil
    @State private var currentTask: String = ""  // Task field
    @State private var showMessageView: Bool = false  // Show/hide message view
    @State private var messageText: String = ""  // Text for message view
    @State private var showNextButton: Bool = false  // Show/hide Next button in message view
    @State private var showSettings: Bool = false  // Show/hide settings view
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var currentAnimation: AnimationType = .originalCube
    @State private var isAnimatingSphere = false
    @State private var isAnimatingRainbowRing = false
    @StateObject private var animationManager = AnimationManager()

    var body: some View {
        ZStack {
            VStack {
                Text(timeString(time: elapsedSeconds))
                    .font(.largeTitle)
                    .padding(.top, 40)

                Spacer()

                ZStack {
                    if currentAnimation == .originalCube {
                        CubeView(rotationAngle: rotationAngle)
                            .frame(width: 100, height: 100)
                            .animation(.easeInOut(duration: 5.0), value: rotationAngle)
                    } else if currentAnimation == .colorful1Cube {
                        CubeView1(rotationAngle: rotationAngle)
                        .frame(width: 100, height: 100)
                        .animation(.easeInOut(duration: 1.0), value: rotationAngle)
                    } else if currentAnimation == .colorful2Cube {
                        CubeView2(rotationAngle: rotationAngle)
                        .frame(width: 100, height: 100)
                        .animation(.easeInOut(duration: 0.9), value: rotationAngle)
                    } else if currentAnimation == .sphere {
                        SphereView(rotationAngle: isAnimatingSphere ? rotationAngle : 0, animationManager: animationManager)
                                            .frame(width: 130, height: 130)
                                            .animation(isAnimatingSphere ? Animation.linear(duration: 10).repeatForever(autoreverses: false) : .none, value: animationManager.isAnimatingSphere)
                    }
                    else if currentAnimation == .rainbowring {
                        RainbowRingView(animationManager: animationManager)
                            .frame(width: 130, height: 130)
                            .animation(isAnimatingRainbowRing ? Animation.linear(duration: 10).repeatForever(autoreverses: false) : .none, value: animationManager.isAnimatingRainbowRing)
                    }
                }
                .onAppear {
                            animationManager.isAnimatingSphere = false // Initialize sphere animation state
                            animationManager.isAnimatingRainbowRing = false // Initialize rainbow ring animation state
                        }


                Spacer()

                TextField("Your task", text: $currentTask)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)

                Button(action: startOrStopStopwatch) {
                    Text(isStopwatchActive ? "Stop" : "Start")
                        .font(.system(size: 20))
                        
                }
                .foregroundColor(Color.primary)
                .padding(.bottom, 30)
                
                Button(action: {
                    showStopwatch = false
                }) {
                    Image(systemName: "timer")
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
            .blur(radius: showMessageView ? 5 : 0)

            if showMessageView {
                // Custom completion message view
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
                                currentTask = ""  // Clear the task field
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"), message: Text(alertMessage), dismissButton: .default(Text("Okay")))
        }

    }

    func startOrStopStopwatch() {
        withAnimation {
            if isStopwatchActive {
                stopwatchTimer?.invalidate()
                isStopwatchActive = false
                elapsedSeconds = 0  // Reset elapsed time to 0
                rotationAngle = 0
                animationManager.isAnimatingSphere = false
                animationManager.isAnimatingRainbowRing = false
                messageText = "Did you complete \(currentTask)?"
                showMessageView = true
                showNextButton = false
            } else {
                if currentTask.isEmpty {
                    alertMessage = "Please enter a task before starting the time."
                    showAlert = true
                    return
                }
                isStopwatchActive = true
                startTime = Date()
                stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    if let startTime = startTime {
                        elapsedSeconds = Int(Date().timeIntervalSince(startTime))
                        rotationAngle += 45
                        animationManager.isAnimatingSphere = true
                        animationManager.isAnimatingRainbowRing = true
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
}

struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView(showStopwatch: .constant(true))
    }
}
