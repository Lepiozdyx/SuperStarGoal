import SwiftUI

struct GoalCardView: View {
    let goal: Goal
    var onTap: () -> Void
    var onDelete: () -> Void
    var onEdit: () -> Void





    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 7) {
                    Text(goal.title)
                        .font(.custom(DesignSystem.Fonts.interRegular, size: 16))
                        .lineSpacing(12)
                        .foregroundColor(.white)
                    Text(goal.progressSubtitle)
                        .font(.custom(DesignSystem.Fonts.interThin, size: 14))
                        .lineSpacing(12)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            ZStack(alignment: .leading) {
                GeometryReader { geo in
                    Capsule()
                        .fill(DesignSystem.Colors.progressBarBackground)
                        .frame(height: 21)
                    Capsule()
                        .fill(goal.accentColor)
                        .frame(width: max(0, geo.size.width * CGFloat(goal.progress)), height: 17)
                        .padding(.leading, 2)
                        .padding(.vertical, 2)
                }
            }
            .frame(height: 21)
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: DesignSystem.Swipe.goalCardMinHeight)
        .background(DesignSystem.Colors.cardBackground)
        .cornerRadius(DesignSystem.Radii.card)
        .contentShape(Rectangle())
        .swipeToReveal(
            revealWidth: DesignSystem.Swipe.goalCardRevealWidth,
            orientation: .vertical,
            onEdit: onEdit,
            onDelete: onDelete,
            onTapped: onTap
        )
    }
}

#Preview {
    ZStack {
        Color.black
        GoalCardView(
            goal: Goal(
                title: "Prepare for a marathon",
                targetDate: Date(),
                subGoals: [
                    SubGoal(title: "A", isCompleted: true),
                    SubGoal(title: "B", isCompleted: false)
                ]
            ),
            onTap: {},
            onDelete: {},
            onEdit: {}
        )
        .padding()
    }
}
