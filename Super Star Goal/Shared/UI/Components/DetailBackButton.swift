import SwiftUI

struct DetailBackButton: View {
    let action: () -> Void

    var body: some View {
        HStack {
            Button(action: action) {
                VStack(alignment: .leading, spacing: 2) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .medium))
                    Text("Back")
                        .font(.custom(DesignSystem.Fonts.interRegular, size: 10))
                }
                .foregroundColor(.white)
            }
            Spacer()
        }
        .padding(.horizontal, 38)
        .padding(.top, 8)
    }
}
