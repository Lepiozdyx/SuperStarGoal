import SwiftUI

struct GoalListView: View {
    @EnvironmentObject private var goalsStore: GoalsStore
    @EnvironmentObject private var router: Router

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Spacer().frame(height: DesignSystem.Spacing.listTop)

                    if goalsStore.goals.isEmpty {
                        EmptyStateView(
                            title: "No goals yet",
                            systemImage: "checkmark.circle",
                            description: "Tap \"+add a goal\" to create your first goal.",
                            titleColor: .white
                        )
                        .padding(.top, 40)
                    } else {
                        VStack(spacing: DesignSystem.Spacing.listBetween) {
                            ForEach(goalsStore.goals) { goal in
                                GoalCardView(
                                    goal: goal,
                                    onTap: { router.showDetail(goal: goal) },
                                    onDelete: { goalsStore.delete(goal) },
                                    onEdit: { router.showGoalEdit(goal: goal) }
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.bottom, DesignSystem.Spacing.addGoalButtonBottomPadding)
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { router.showCreation() }) {
                        Text("+add a goal")
                            .font(.custom(DesignSystem.Fonts.interSemiBold, size: 17))
                            .foregroundColor(.white)
                            .frame(width: 166, height: 34)
                            .background(DesignSystem.primaryGradient)
                            .cornerRadius(DesignSystem.Radii.button)
                    }
                    .padding(.bottom, DesignSystem.Spacing.addGoalButtonBottomPadding)
                    .padding(.trailing, DesignSystem.Spacing.screenHorizontal)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        GoalListView()
            .environmentObject(GoalsStore())
            .environmentObject(Router())
    }
}
