import SwiftUI

struct ScreenBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            GeometryReader { _ in
                Image("Background")
                    .resizable()
                    .scaledToFill()
            }
            .ignoresSafeArea()

            Rectangle()
                .foregroundColor(.clear)
                .background(DesignSystem.backgroundOverlayGradient)
                .opacity(0.64)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                AppLogoView()
                Spacer()
            }

            RoundedRectangle(cornerRadius: DesignSystem.Radii.glass)
                .fill(DesignSystem.Colors.glassFrame)
                .padding(.horizontal, 16)
                .ignoresSafeArea()

            content
        }
    }
}

extension View {
    func screenBackground() -> some View {
        modifier(ScreenBackground())
    }
}
