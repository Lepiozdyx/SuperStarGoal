import SwiftUI

struct AppLogoView: View {
    @Environment(\.isCompactScreen) private var isCompactScreen: Bool

    private var logoHeight: CGFloat {
        isCompactScreen ? 120 : DesignSystem.Spacing.logoHeight / 1.3
    }

    var body: some View {
        Image("Logo")
            .resizable()
            .scaledToFit()
            .frame(height: logoHeight)
    }
}

