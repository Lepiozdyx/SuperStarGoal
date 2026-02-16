import SwiftUI

struct MainTabView: View {
    @StateObject private var router = Router()
    @StateObject private var goalsStore = GoalsStore()
    @State private var selectedTab: Int = 2
    @State private var calendarSelectedDate = Date()

    var body: some View {
        GeometryReader { geo in
            NavigationStack(path: $router.path) {
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

                        ZStack {
                            RoundedRectangle(cornerRadius: DesignSystem.Radii.glass)
                                .fill(DesignSystem.Colors.glassFrame)

                            Group {
                                switch selectedTab {
                                case 0:
                                    StatisticsView()
                                case 1:
                                    CalendarView(selectedDate: $calendarSelectedDate)
                                case 2:
                                    GoalListView()
                                default:
                                    GoalListView()
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea(edges: .bottom)
                    }
                    .overlay(alignment: .bottom) {
                        tabBar
                    }
                }
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .goalCreation:
                        GoalCreationView()
                    case .goalEdit(let goal):
                        GoalCreationView(goalToEdit: goal)
                    case .goalDetail(let goal):
                        GoalDetailView(goal: goal)
                    case .subGoalCreation(let goal):
                        SubGoalCreationView(goal: goal)
                    case .calendarDayDetail(let date):
                        CalendarDayDetailView(date: date)
                    }
                }
                .environment(\.isCompactScreen, geo.size.height < 700)
            }
        }
        .environmentObject(router)
        .environmentObject(goalsStore)
    }

    private var tabBar: some View {
        GeometryReader { geo in
            let barWidth = min(geo.size.width - 40, 371)
            let innerWidth = barWidth - 7
            let pillWidth = innerWidth / 3

            ZStack {
                RoundedRectangle(cornerRadius: 41)
                    .fill(DesignSystem.Colors.tabBarBackground)
                    .frame(width: barWidth, height: DesignSystem.Spacing.tabBarHeight)

                HStack(spacing: 2) {
                    tabItem(index: 0, title: "Statistics", icon: "TabStatistics", selectedIcon: "TabStatisticsSelected", pillWidth: pillWidth)
                    tabItem(index: 1, title: "Calendar", icon: "TabCalendar", selectedIcon: "TabCalendarSelected", pillWidth: pillWidth)
                    tabItem(index: 2, title: "Goals", icon: "IconCheck", selectedIcon: "IconCheckSelected", pillWidth: pillWidth)
                }
                .frame(width: innerWidth, height: 56)
            }
            .frame(width: barWidth, height: DesignSystem.Spacing.tabBarHeight)
            .frame(maxWidth: .infinity)
        }
        .frame(height: DesignSystem.Spacing.tabBarHeight)
        .padding(.bottom, DesignSystem.Spacing.tabBarBottomPadding)
    }

    private func tabItem(index: Int, title: String, icon: String, selectedIcon: String, pillWidth: CGFloat) -> some View {
        let isSelected = selectedTab == index
        return Button {
            selectedTab = index
        } label: {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 36)
                        .fill(DesignSystem.primaryGradient)
                        .frame(width: pillWidth, height: 56)
                }

                VStack(spacing: 4) {
                    Image(isSelected ? selectedIcon : icon)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(isSelected ? .white : DesignSystem.Colors.tabInactive)

                    Text(title)
                        .font(.custom(DesignSystem.Fonts.interSemiBold, size: 10))
                        .lineSpacing(12)
                        .foregroundColor(isSelected ? .white : DesignSystem.Colors.tabInactive)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView()
}
