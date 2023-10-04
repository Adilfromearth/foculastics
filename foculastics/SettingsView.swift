import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showShareSheet = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Rectangle()
                        .frame(width: 40, height: 4)
                        .foregroundColor(Color.gray)
                        .cornerRadius(2)
                        .padding(.top, 20)
                }
                Spacer()
            }
            
            Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .padding(.top, 5)
            
            Text("Foculastics")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 15)
            
            VStack(alignment: .leading, spacing: 25) {
                Button(action: {
                    showShareSheet = true
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                            .frame(width: 24, height: 24)
                        Spacer().frame(width: 20)
                        Text("Share")
                            .foregroundColor(Color.primary)
                    }
                    .padding(.leading, 20)
                    .font(.title2)
                }
                .sheet(isPresented: $showShareSheet) {
                    ShareSheet(activityItems: ["Foculastics - your tool for most productive work!"])
                }

                Link(destination: URL(string: "http://foculastics.com/help.html")!) {
                    HStack {
                        Image(systemName: "questionmark")
                            .frame(width: 24, height: 24)
                        Spacer().frame(width: 20)
                        Text("Help")
                            .foregroundColor(Color.primary)
                    }
                    .padding(.leading, 20)
                    .font(.title2)
                }
                
                Link(destination: URL(string: "http://foculastics.com/feedback.html")!) {
                    HStack {
                        Image(systemName: "bubble.left")
                            .frame(width: 24, height: 24)
                        Spacer().frame(width: 20)
                        Text("Feedback")
                            .foregroundColor(Color.primary)
                    }
                    .padding(.leading, 20)
                    .font(.title2)
                }
                
                Link(destination: URL(string: "http://foculastics.com/privacy-terms.html")!) {
                    HStack {
                        Image(systemName: "lock")
                            .frame(width: 24, height: 24)
                        Spacer().frame(width: 20)
                        Text("Privacy Policy & Terms of Use")
                            .foregroundColor(Color.primary)
                    }
                    .padding(.horizontal, 20)
                    .font(.title2)
                }
            }
            .foregroundColor(Color.primary)
            
            Spacer()
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Not needed
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
