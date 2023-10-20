import SwiftUI
import Combine

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
        }
    }
}

struct CubeView1: View {
    let rotationAngle: Double

    var body: some View {
        ZStack {
            // Front side
            Rectangle()
                .fill(Color.blue)
                .cornerRadius(20)
                .frame(width: 100, height: 100)
                .rotation3DEffect(
                    .degrees(rotationAngle), // Rotate the cube
                    axis: (x: 0, y: 1, z: 0), // Around the Y-axis
                    anchor: .center,
                    perspective: 1.0
                )
                .zIndex(1)

            // Right side
            Rectangle()
                .fill(Color.green)
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
                .fill(Color.yellow)
                .cornerRadius(20)
                .frame(width: 100, height: 100)
                .rotation3DEffect(
                    .degrees(rotationAngle + 90), // Rotate the cube
                    axis: (x: 1, y: 0, z: 0), // Around the X-axis
                    anchor: .center,
                    perspective: 1.0
                )
                .zIndex(0)
        }
    }
}

struct CubeView2: View {
    let rotationAngle: Double

    var body: some View {
        ZStack {
            // Front side
            Rectangle()
                .fill(Color.purple)
                .cornerRadius(20)
                .frame(width: 100, height: 100)
                .rotation3DEffect(
                    .degrees(rotationAngle), // Rotate the cube
                    axis: (x: 0, y: 1, z: 0), // Around the Y-axis
                    anchor: .center,
                    perspective: 1.0
                )
                .zIndex(1)

            // Right side
            Rectangle()
                .fill(Color.pink)
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
                .fill(Color.blue)
                .cornerRadius(20)
                .frame(width: 100, height: 100)
                .rotation3DEffect(
                    .degrees(rotationAngle + 90), // Rotate the cube
                    axis: (x: 1, y: 0, z: 0), // Around the X-axis
                    anchor: .center,
                    perspective: 1.0
                )
                .zIndex(0)
        }
    }
}

struct SphereView: View {
    let rotationAngle: Double
    @Binding var isAnimating: Bool

    var body: some View {
        Circle()
            .fill(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .top, endPoint: .bottom))
            .frame(width: isAnimating ? 110 : 100, height: isAnimating ? 110 : 100)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 5, y: 5)
            .rotationEffect(.degrees(rotationAngle))
            .scaleEffect(isAnimating ? 1.1 : 1.0)
            .animation(isAnimating ? Animation.easeInOut(duration: 1).repeatForever(autoreverses: true) : .none, value: isAnimating)
    }
}


struct RainbowRingView: View {
    @Binding var isAnimating: Bool

    let gradientColors: [Color] = [Color.purple, Color.blue, Color.green, Color.yellow, Color.orange, Color.red, Color.purple]

    var body: some View {
        ZStack {
            Circle()
                .fill(AngularGradient(gradient: Gradient(colors: gradientColors), center: .center))
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(isAnimating ? Animation.linear(duration: 10).repeatForever(autoreverses: false) : .none, value: isAnimating)
            
            Circle()
                .strokeBorder(AngularGradient(gradient: Gradient(colors: gradientColors), center: .center), lineWidth: 5)
                .frame(width: isAnimating ? 99 : 90, height: isAnimating ? 99 : 90)
                .animation(isAnimating ? Animation.easeInOut(duration: 1).repeatForever(autoreverses: true) : .none, value: isAnimating)
        }
    }
}








enum AnimationType {
    case originalCube
    case colorful1Cube
    case colorful2Cube
    case sphere
    case rainbowring
}
