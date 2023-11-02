import SwiftUI
import Combine

class AnimationManager: ObservableObject {
    @Published var isAnimatingSphere: Bool = false
    @Published var isAnimatingRainbowRing: Bool = false
    @Published var animationProgress: Double = 0.0
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
                .fill(Color.yellow)
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
                .fill(Color.red)
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
    @ObservedObject var animationManager: AnimationManager

    var body: some View {
        Circle()
            .fill(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red, Color.purple]), startPoint: .top, endPoint: .bottom))
            .frame(width: animationManager.isAnimatingSphere ? 140 : 130, height: animationManager.isAnimatingSphere ? 140 : 130)
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 5, y: 5)
            .rotationEffect(.degrees(rotationAngle))
            .scaleEffect(animationManager.isAnimatingSphere ? 1.1 : 1.0)
            .animation(animationManager.isAnimatingSphere ? Animation.easeInOut(duration: 1).repeatForever(autoreverses: true) : .none, value: animationManager.isAnimatingSphere)
    }
}

struct RainbowRingView: View {
    @ObservedObject var animationManager: AnimationManager

    let gradientColors: [Color] = [Color.purple, Color.blue, Color.green, Color.yellow, Color.orange, Color.red, Color.purple]

    var body: some View {
        ZStack {
            Circle()
                .fill(AngularGradient(gradient: Gradient(colors: gradientColors), center: .center))
                .frame(width: 130, height: 130)
                .rotationEffect(.degrees(animationManager.isAnimatingRainbowRing ? 360 : 0))
                .animation(animationManager.isAnimatingRainbowRing ? Animation.linear(duration: 10).repeatForever(autoreverses: false) : .none, value: animationManager.isAnimatingRainbowRing)
            
            Circle()
                .strokeBorder(AngularGradient(gradient: Gradient(colors: gradientColors), center: .center), lineWidth: 5)
                .frame(width: animationManager.isAnimatingRainbowRing ? 129 : 70, height: animationManager.isAnimatingRainbowRing ? 129 : 70)
                .animation(animationManager.isAnimatingRainbowRing ? Animation.easeInOut(duration: 3).repeatForever(autoreverses: true) : .none, value: animationManager.isAnimatingRainbowRing)
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
