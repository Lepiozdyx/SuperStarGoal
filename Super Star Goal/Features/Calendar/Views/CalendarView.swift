import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    @EnvironmentObject private var goalsStore: GoalsStore
    @EnvironmentObject private var router: Router

    private var allEventDates: Set<DateComponents> {
        let cal = Calendar.current
        var set = Set<DateComponents>()
        for goal in goalsStore.goals {
            for sub in goal.subGoals where sub.isCompleted {
                if let date = sub.completedAt {
                    set.insert(cal.dateComponents([.year, .month, .day], from: date))
                }
            }
        }
        return set
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                Spacer().frame(height: 24)

                MonthCalendarView(
                    selectedDate: $selectedDate,
                    style: .detail,
                    eventDates: allEventDates
                )
                .onDayTapped { date in
                    router.showCalendarDayDetail(date: date)
                }
                .padding(.horizontal, 8)

                Spacer()
                    .frame(height: DesignSystem.Spacing.tabBarHeight + DesignSystem.Spacing.tabBarBottomPadding + 20)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black
        CalendarView(selectedDate: .constant(Date()))
            .environmentObject(GoalsStore())
            .environmentObject(Router())
    }
}

