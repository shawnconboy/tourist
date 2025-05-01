import SwiftUI

// MARK: - Theme Colors
enum Theme {
    static let darkBlue = Color(red: 0.0, green: 0.18, blue: 0.38)
    static let lightGrayBackground = Color(.systemGray6)
    static let softShadow = Color.black.opacity(0.05)
    static let dealGreen = Color.green
    static let subtitleText = Color.secondary
}

// MARK: - Layout Constants
enum Layout {
    static let cornerRadius: CGFloat = 14
    static let cardPadding: CGFloat = 16
    static let imageHeight: CGFloat = 240
    static let horizontalPadding: CGFloat = 16
}

// MARK: - Text Styles
struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.bold)
    }
}

struct SubtitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .foregroundColor(Theme.subtitleText)
    }
}

struct SectionTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.semibold)
            .padding(.horizontal, Layout.horizontalPadding)
    }
}

// MARK: - View Extensions for Easy Usage
extension View {
    func titleStyle() -> some View {
        self.modifier(TitleStyle())
    }

    func subtitleStyle() -> some View {
        self.modifier(SubtitleStyle())
    }

    func sectionTitleStyle() -> some View {
        self.modifier(SectionTitleStyle())
    }

    func cardStyle() -> some View {
        self
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(Layout.cornerRadius)
            .shadow(color: Theme.softShadow, radius: 4, x: 0, y: 4)
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .background(Theme.darkBlue)
            .foregroundColor(.white)
            .cornerRadius(Layout.cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
    }
}
