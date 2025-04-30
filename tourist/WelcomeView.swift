import SwiftUI

struct WelcomeView: View {
    @State private var animate = false
    @State private var showTabs = false

    var body: some View {
        ZStack {
            if showTabs {
                MainTabView()
            } else {
                VStack(spacing: 24) {
                    Image(systemName: "location.north.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.accentColor)
                        .scaleEffect(animate ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animate)

                    Text("Let's explore")
                        .font(.title2)
                        .opacity(animate ? 1 : 0.7)
                        .animation(.easeIn(duration: 1), value: animate)

                    Text("Charleston")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                        .opacity(animate ? 1 : 0.7)
                        .animation(.easeIn(duration: 1.2), value: animate)

                    Text("Swipe through the tabs to discover beaches, food, deals, and more! 🎉")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 12)
                }
                .padding(.horizontal, 24)
                .multilineTextAlignment(.center)
                .onAppear {
                    animate = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showTabs = true
                        }
                    }
                }
                .transition(.opacity)
            }
        }
    }
}
