//
//  TutorialView.swift
//  foculastics
//
//  Created by Adil on 26.09.2023.
//
import SwiftUI

struct TutorialView: View {
    @Binding var showTutorial: Bool
    
    var body: some View {
        ZStack {
            // Your main content
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 160)
                    .padding(.bottom, 10)
                    .padding(.top)
                
                Text("Welcome to Foculastics!")
                    .font(.title)
                    .padding(.bottom, 10)
                
                Text("Achieve your full productivity")
                    .font(.headline)
                    .fontWeight(.light)
                    .padding(.bottom, 20)
                
                TutorialStepView(icon: "timer", title: "Timer Modes", description: "Choose the classic 25-minute Pomodoro or set your own custom duration.")
                TutorialStepView(icon: "stopwatch.fill", title: "Stopwatch", description: "Just start and let it run. Track your uninterrupted focus sessions.")
                TutorialStepView(icon: "square.stack.3d.up.fill", title: "Visual Motivation", description: "Watch the engaging aniamtion as time progresses, fueling your focus.")
                TutorialStepView(icon: "bell", title: "Breaks", description: "Take short breaks after each session to recover.")
                
                Text("Enjoy your work!")
                    .font(.headline)
                    .fontWeight(.light)
                    .padding(.top, 25)
            }
            
            // Rectangle on the top with padding above
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.showTutorial = false
                    }) {
                        Rectangle()
                            .frame(width: 40, height: 4)
                            .foregroundColor(Color.gray)
                            .cornerRadius(2)
                            .padding(.top, 20)  // Padding above the rectangle
                    }
                    Spacer()
                }
                Spacer()  // Push the rectangle to the top
            }
        }
    }
}


struct TutorialStepView: View {
    var icon: String
    var title: String
    var description: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 26, height: 26)
                .padding(.leading, 50)  // Increase this to add more left padding
                .fixedSize()  // Ensure icon size does not change
            
            Spacer().frame(width: 30)  // Increase the space to the right side of the icons
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(description)
                    .font(.footnote)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.trailing, 30)  // Increase this to add more right padding to the text
            .frame(maxWidth: .infinity, alignment: .leading)  // Assign a maximum width to the VStack
        }
        .padding([.leading, .trailing], 10)  // Padding for left and right
        .frame(minHeight: 60) // Min height to ensure some consistency, but it can grow
        .padding(.bottom, 5) // Reduced padding at the bottom
    }
}


struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView(showTutorial: .constant(true))
    }
}
