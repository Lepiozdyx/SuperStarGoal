import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject private var goalsStore: GoalsStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                Spacer().frame(height: DesignSystem.Spacing.listTop)

                Text("Top Goals")
                    .font(.custom(DesignSystem.Fonts.interBold, size: 20))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 12)

                if goalsStore.goals.isEmpty {
                    EmptyStateView(
                        title: "No goals yet",
                        systemImage: "chart.bar",
                        description: "Create goals to see your statistics.",
                        titleColor: .white
                    )
                    .padding(.top, 40)
                } else {
                    VStack(spacing: 16) {
                        ForEach(goalsStore.goals) { goal in
                            GoalSummaryCard(goal: goal)
                        }
                    }
                    .padding(.bottom, 24)

                    WeeklyProgressChart(goals: goalsStore.goals)
                }

            }
            .padding(.horizontal, 22)
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: DesignSystem.Spacing.tabBarHeight + DesignSystem.Spacing.tabBarBottomPadding + 20)
        }
    }
}

// Goal Summary Card

private struct GoalSummaryCard: View {
    let goal: Goal

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(goal.title)
                .font(.custom(DesignSystem.Fonts.interBold, size: 20))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)

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

            Text(goal.progressSubtitle)
                .font(.custom(DesignSystem.Fonts.interThin, size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)

            Text(goal.subGoalsSubtitle)
                .font(.custom(DesignSystem.Fonts.interThin, size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
    }
}

// Weekly Progress Chart

private struct GoalSegment: Identifiable {
    let id = UUID()
    let count: Int
    let color: Color
}

private struct WeeklyProgressChart: View {
    let goals: [Goal]

    private let dayLabels = ["S", "M", "T", "W", "T", "F", "S"]
    private var weekCalendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = .current
        cal.locale = .current
        cal.firstWeekday = 1
        return cal
    }

    private var startOfCurrentWeek: Date? {
        let cal = weekCalendar
        let comps = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        return cal.date(from: comps).map { cal.startOfDay(for: $0) }
    }

    // Group completions by day for the stacked bar
    private var stackedWeekData: [[GoalSegment]] {
        let cal = weekCalendar
        guard let startOfWeek = startOfCurrentWeek else {
            return Array(repeating: [], count: 7)
        }

        var map: [Int: [UUID: Int]] = [:]
        for dayIndex in 0..<7 { map[dayIndex] = [:] }

        for goal in goals {
            for sub in goal.subGoals where sub.isCompleted {
                guard let completedAt = sub.completedAt else { continue }
                let completedDay = cal.startOfDay(for: completedAt)
                let diff = cal.dateComponents([.day], from: startOfWeek, to: completedDay).day ?? -1
                if diff >= 0 && diff < 7 {
                    map[diff, default: [:]][goal.id, default: 0] += 1
                }
            }
        }

        var result: [[GoalSegment]] = []
        for dayIndex in 0..<7 {
            let dayMap = map[dayIndex] ?? [:]
            var segments: [GoalSegment] = []
            for goal in goals {
                if let count = dayMap[goal.id], count > 0 {
                    segments.append(GoalSegment(count: count, color: goal.accentColor))
                }
            }
            result.append(segments)
        }
        return result
    }

    private var totalPerDay: [Int] {
        stackedWeekData.map { segments in segments.reduce(0) { $0 + $1.count } }
    }

    private var maxValue: Int {
        max(totalPerDay.max() ?? 0, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("weekly progress on all goals")
                .font(.custom(DesignSystem.Fonts.interLight, size: 14))
                .foregroundColor(DesignSystem.Colors.chartAxisText)
                .textCase(.uppercase)

            chartBody

            if !goals.isEmpty {
                legendView
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(17)
    }

    private var chartBody: some View {
        let chartTopValue = max(maxValue, 5)
        let steps = 5
        let chartHeight: CGFloat = CGFloat(steps) * 40

        return HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .trailing, spacing: 0) {
                ForEach((0...steps).reversed(), id: \.self) { index in
                    let value = Int(ceil(Double(chartTopValue) / Double(steps) * Double(index)))
                    Text("\(value)")
                        .font(.custom(DesignSystem.Fonts.interRegular, size: 12))
                        .foregroundColor(DesignSystem.Colors.chartAxisText)
                        .frame(height: 40)
                }
            }
            .frame(width: 20)
            .padding(.trailing, 8)

            HStack(alignment: .bottom, spacing: 0) {
                ForEach(0..<7, id: \.self) { index in
                    let segments = stackedWeekData[index]
                    let total = totalPerDay[index]

                    VStack(spacing: 4) {
                        Spacer()

                        if total > 0 {
                            VStack(spacing: 0) {
                                ForEach(segments) { segment in
                                    let segmentHeight = CGFloat(segment.count) / CGFloat(chartTopValue) * chartHeight
                                    Rectangle()
                                        .fill(segment.color)
                                        .frame(width: 26, height: max(segmentHeight, 4))
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                        }

                        Text(dayLabels[index])
                            .font(.custom(DesignSystem.Fonts.interRegular, size: 20))
                            .foregroundColor(index == 0
                                ? DesignSystem.Colors.sundayRed
                                : DesignSystem.Colors.chartAxisText)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .frame(height: chartHeight + 40)
    }

    private var legendView: some View {
        let activeGoals = goals.filter { goal in
            goal.subGoals.contains { $0.isCompleted && $0.completedAt != nil }
        }
        return VStack(alignment: .leading, spacing: 6) {
            ForEach(activeGoals) { goal in
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(goal.accentColor)
                        .frame(width: 14, height: 14)
                    Text(goal.title)
                        .font(.custom(DesignSystem.Fonts.interRegular, size: 13))
                        .foregroundColor(DesignSystem.Colors.chartAxisText)
                        .lineLimit(1)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        StatisticsView()
            .environmentObject(GoalsStore())
    }
}
