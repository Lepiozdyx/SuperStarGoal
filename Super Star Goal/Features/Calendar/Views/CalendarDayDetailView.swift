import SwiftUI

struct CalendarDayDetailView: View {
    let date: Date
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var goalsStore: GoalsStore



    /// All goals that have subgoals completed on this date
    private var eventsForDay: [(goal: Goal, subGoals: [SubGoal])] {
        let cal = Calendar.current
        var results: [(Goal, [SubGoal])] = []
        for goal in goalsStore.goals {
            let matching = goal.subGoals.filter { sub in
                guard sub.isCompleted, let completedAt = sub.completedAt else { return false }
                return cal.isDate(completedAt, inSameDayAs: date)
            }
            if !matching.isEmpty {
                results.append((goal, matching))
            }
        }
        return results
    }

    var body: some View {
        VStack(spacing: 0) {
            DetailBackButton { router.pop() }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    Text(DesignSystem.Formatters.shortDate.string(from: date))
                        .font(.custom(DesignSystem.Fonts.interBold, size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 16)
                        .padding(.bottom, 24)

                    if eventsForDay.isEmpty {
                        EmptyStateView(
                            title: "No events",
                            systemImage: "calendar",
                            description: "No completed subgoals on this day.",
                            titleColor: .white
                        )
                        .padding(.top, 24)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(eventsForDay, id: \.goal.id) { entry in
                                ForEach(entry.subGoals) { sub in
                                    EventRow(subGoal: sub)
                                }

                                GoalInfoCard(goal: entry.goal)
                            }
                        }
                    }
                }
                .padding(.horizontal, 38)
                .padding(.bottom, 40)
            }

            HStack {
                Spacer()
                Button(action: {
                    router.showCreation()
                }) {
                    Text("+add an event")
                        .font(.custom(DesignSystem.Fonts.interSemiBold, size: 17))
                        .foregroundColor(.white)
                        .frame(width: 166, height: 34)
                        .background(DesignSystem.primaryGradient)
                        .cornerRadius(DesignSystem.Radii.button)
                }
                .padding(.bottom, 24)
                .padding(.trailing, 22)
            }
        }
        .screenBackground()
        .navigationBarBackButtonHidden(true)
    }
}

// Event Row

private struct EventRow: View {
    let subGoal: SubGoal

    var body: some View {
        HStack(spacing: 10) {
            Text(subGoal.title)
                .font(.custom(DesignSystem.Fonts.interSemiBold, size: 16))
                .foregroundColor(DesignSystem.Colors.subGoalText)

            Spacer()

            Text("Done")
                .font(.custom(DesignSystem.Fonts.interRegular, size: 16))
                .foregroundColor(DesignSystem.Colors.accentGreen)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(DesignSystem.Radii.input)
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radii.input)
                .inset(by: 1)
                .stroke(DesignSystem.Colors.inputBorder, lineWidth: 1)
        )
    }
}

// Goal Info Card

private struct GoalInfoCard: View {
    let goal: Goal

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(goal.title)
                .font(.custom(DesignSystem.Fonts.interBold, size: 20))
                .foregroundColor(.white)

            Text(goal.progressSubtitle)
                .font(.custom(DesignSystem.Fonts.interThin, size: 14))
                .foregroundColor(.white)

            Text(goal.subGoalsSubtitle)
                .font(.custom(DesignSystem.Fonts.interThin, size: 14))
                .foregroundColor(.white)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(DesignSystem.Colors.progressBarBackground)
                        .frame(height: 21)
                    RoundedRectangle(cornerRadius: 24)
                        .fill(goal.accentColor)
                        .frame(
                            width: max(0, (geo.size.width - 4) * goal.progress),
                            height: 17
                        )
                        .padding(2)
                }
            }
            .frame(height: 21)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(DesignSystem.Colors.cardBackground)
        .cornerRadius(DesignSystem.Radii.card)
    }
}

#Preview {
    CalendarDayDetailView(date: Date())
        .environmentObject(Router())
        .environmentObject(GoalsStore())
}
