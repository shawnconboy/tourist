import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.7
    @State private var opacity = 0.0
    @State private var fadeOut = false

    var body: some View {
        ZStack {
            if isActive {
                MainTabView()
                    .transition(.opacity)
            } else {
                VStack {
                    Image("App_Icon_Transparent") // 👈 name of your transparent PNG asset
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .shadow(radius: 10)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LinearGradient(
                    colors: [Color("SplashTop"), Color("SplashBottom")],
                    startPoint: .top, endPoint: .bottom)
                )
                .ignoresSafeArea()
                .opacity(fadeOut ? 0 : 1)
                .onAppear {
                    // Fade & scale in
                    withAnimation(.easeOut(duration: 1.2)) {
                        self.scale = 1.0
                        self.opacity = 1.0
                    }

                    // Wait, then fade out and switch view
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            self.fadeOut = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
                }
            }
        }
        .animation(.easeInOut, value: isActive)
    }
}
