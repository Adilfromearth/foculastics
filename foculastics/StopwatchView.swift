import SwiftUI

struct StopwatchView: View {
    @Binding var showStopwatch: Bool
    @State private var elapsedSeconds: Int = 0
    @State private var stopwatchTimer: Timer? = nil
    @State private var isStopwatchActive = false
    @State private var showSettings: Bool = false
    @State private var rotationAngle: Double = 0 // Angle for cube rotation

    var body: some View {
        VStack {
            Text(timeString(time: elapsedSeconds))
                .font(.largeTitle)
                .padding(.top, 40)

            Spacer()

            ZStack {
                CubeView(rotationAngle: rotationAngle)
                    .frame(width: 100, height: 100) // Size of the cube

                // Offset the cube slightly downward
                .offset(x: 0, y: 20)

                // Rotate the cube and add animation
                .animation(.easeInOut(duration: 1.0), value: rotationAngle)
            }

            Spacer()

            Button(action: startOrStopStopwatch) {
                Text(isStopwatchActive ? "Stop" : "Start")
            }
            .foregroundColor(Color.primary)
            .padding(.bottom, 30)

            Button(action: {
                showStopwatch = false
            }) {
                Image(systemName: "timer")
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
        .onDisappear {
            stopwatchTimer?.invalidate()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }

    func startOrStopStopwatch() {
        if isStopwatchActive {
            stopwatchTimer?.invalidate()
            isStopwatchActive = false
            elapsedSeconds = 0
            rotationAngle = 0 // Reset the rotation angle
        } else {
            isStopwatchActive = true
            stopwatchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                elapsedSeconds += 1
                rotationAngle += 45 // Rotate the cube by 45 degrees
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

struct CubeView: View {
    let rotationAngle: Double

    var body: some View {
        ZStack {
            // Front side
            Rectangle()
                .fill(Color(UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1)))
                .cornerRadius(20)
                .frame(width: 100, height: 100)
                .rotation3DEffect(
                    .degrees(rotationAngle), // Rotate the cube
                    axis: (x: 0, y: 1, z: 0), // Around the Y-axis
                    anchor: .center,
                    perspective: 1.0
                )
                .zIndex(1)

            // Left side
            Rectangle()
                .fill(Color.red)
                .cornerRadius(20)
                .frame(width: 100, height: 100)
                .rotation3DEffect(
                    .degrees(rotationAngle - 90), // Rotate the cube
                    axis: (x: 0, y: 1, z: 0), // Around the Y-axis
                    anchor: .center,
                    perspective: 1.0
                )
                .zIndex(0)

            // Right side
            Rectangle()
                .fill(Color(UIColor(red: 84/255, green: 84/255, blue: 84/255, alpha: 1)))
                .cornerRadius(20)
                .frame(width: 100, height: 100)
                .rotation3DEffect(
                    .degrees(rotationAngle + 90), // Rotate the cube
                    axis: (x: 0, y: 1, z: 0), // Around the Y-axis
                    anchor: .center,
                    perspective: 1.0
                )
                .zIndex(0)

            // Top side
            Rectangle()
                .fill(Color(UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)))
                .cornerRadius(20)
                .frame(width: 100, height: 100)
                .rotation3DEffect(
                    .degrees(rotationAngle + 90), // Rotate the cube
                    axis: (x: 1, y: 0, z: 0), // Around the X-axis
                    anchor: .center,
                    perspective: 1.0
                )
                .zIndex(0)

            // Back side
            Rectangle()
                .fill(Color.orange)
                .cornerRadius(20)
                .frame(width: 100, height: 100)
                .rotation3DEffect(
                    .degrees(rotationAngle + 180), // Rotate the cube
                    axis: (x: 0, y: 1, z: 0), // Around the Y-axis
                    anchor: .center,
                    perspective: 1.0
                )
                .zIndex(0)
        }
    }
}
