import SwiftUI

struct EmptyStateView: View {
    let title: String
    let systemImage: String
    let description: String
    var titleColor: Color = .white
    var descriptionColor: Color = .white.opacity(0.7)

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundColor(titleColor.opacity(0.8))
            Text(title)
                .font(.custom(DesignSystem.Fonts.interSemiBold, size: 17))
                .foregroundColor(titleColor)
            Text(description)
                .font(.custom(DesignSystem.Fonts.interRegular, size: 14))
                .foregroundColor(descriptionColor)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 32)
    }
}
