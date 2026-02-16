import SwiftUI

struct GoalDetailView: View {
    let goal: Goal
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var goalsStore: GoalsStore

    var body: some View {
        GoalDetailBody(goal: goal, store: goalsStore, router: router)
    }
}

private enum DetailTab {
    case checklist
    case calendar
}

private struct GoalDetailBody: View {
    let goal: Goal
    let store: GoalsStore
    let router: Router
    @StateObject private var viewModel: GoalDetailViewModel
    @State private var selectedTab: DetailTab = .checklist
    @State private var calendarDate: Date
    @State private var showGoalEditSheet = false
    @State private var subGoalToEdit: SubGoal?

    init(goal: Goal, store: GoalsStore, router: Router) {
        self.goal = goal
        self.store = store
        self.router = router
        _viewModel = StateObject(wrappedValue: GoalDetailViewModel(goal: goal, store: store))
        _calendarDate = State(initialValue: goal.targetDate)
    }



    var body: some View {
        VStack(spacing: 0) {
            DetailBackButton { router.popToRoot() }

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    titleSection
                    progressSection
                    datesSection
                    tabButtons
                    tabContent
                }
                .padding(.horizontal, 38)
                .padding(.bottom, 40)
            }
        }
        .screenBackground()
        .sheet(isPresented: $showGoalEditSheet) {
            GoalCreationView(goalToEdit: viewModel.goal)
                .environmentObject(router)
                .environmentObject(store)
        }
        .sheet(item: $subGoalToEdit, onDismiss: { subGoalToEdit = nil }) { sub in
            SubGoalCreationView(goal: viewModel.goal, subGoalToEdit: sub)
                .environmentObject(router)
                .environmentObject(store)
        }
        .navigationBarBackButtonHidden(true)
    }


    private var titleSection: some View {
        HStack(spacing: 8) {
            Spacer()
            Text(viewModel.goal.title)
                .font(.custom(DesignSystem.Fonts.interBold, size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Button(action: { showGoalEditSheet = true }) {
                Image("IconPencil")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white.opacity(0.8))
            }
            .buttonStyle(.plain)
            Spacer()
        }
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    private var progressSection: some View {
        VStack(spacing: 4) {
            GeometryReader { g in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(DesignSystem.Colors.progressBarBackground)
                        .frame(height: 21)
                    RoundedRectangle(cornerRadius: 24)
                        .fill(DesignSystem.Colors.accentGreen)
                        .frame(
                            width: max(0, (g.size.width - 4) * viewModel.goal.progress),
                            height: 17
                        )
                        .padding(2)
                }
            }
            .frame(height: 21)

            Text(viewModel.goal.progressSubtitle)
                .font(.custom(DesignSystem.Fonts.interThin, size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.bottom, 16)
    }

    private var datesSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Date of creation \(DesignSystem.Formatters.shortDate.string(from: viewModel.goal.createdAt))")
                .font(.custom(DesignSystem.Fonts.interRegular, size: 16))
                .foregroundColor(.white)
            Text("Completion date \(DesignSystem.Formatters.shortDate.string(from: viewModel.goal.targetDate))")
                .font(.custom(DesignSystem.Fonts.interRegular, size: 16))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 24)
    }

    private var tabButtons: some View {
        HStack(spacing: 12) {
            tabButton(title: "checklist", tab: .checklist)
            tabButton(title: "calendar", tab: .calendar)
        }
        .padding(.bottom, 24)
    }

    private func tabButton(title: String, tab: DetailTab) -> some View {
        let isActive = selectedTab == tab
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab
            }
        } label: {
            Text(title)
                .font(.custom(DesignSystem.Fonts.interSemiBold, size: 17))
                .foregroundColor(isActive ? .black : .white)
                .frame(maxWidth: .infinity)
                .frame(height: 34)
                .background(isActive
                    ? DesignSystem.createButtonGradient
                    : DesignSystem.primaryGradient
                )
                .cornerRadius(DesignSystem.Radii.button)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .checklist:
            checklistContent
        case .calendar:
            calendarContent
        }
    }

    @ViewBuilder
    private var checklistContent: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.goal.subGoals) { sub in
                ChecklistSubGoalRow(
                    subGoal: sub,
                    dateText: subGoalDateText(sub),
                    onToggle: { viewModel.toggleSubGoal(sub) },
                    onDelete: { viewModel.deleteSubGoal(sub) },
                    onEdit: { subGoalToEdit = sub }
                )
            }
        }
        .padding(.bottom, 16)

        HStack {
            Spacer()
            Button(action: {
                router.showSubGoalCreation(goal: viewModel.goal)
            }) {
                Text("+add a subgoal")
                    .font(.custom(DesignSystem.Fonts.interSemiBold, size: 17))
                    .foregroundColor(.white)
                    .frame(width: 166, height: 34)
                    .background(DesignSystem.primaryGradient)
                    .cornerRadius(DesignSystem.Radii.button)
            }
        }
    }

    private var calendarContent: some View {
        VStack(spacing: 16) {
            MonthCalendarView(
                selectedDate: $calendarDate,
                style: .detail,
                eventDates: viewModel.allEventDateComponents
            )

            let completed = viewModel.subGoalsCompleted(on: calendarDate)
            let scheduled = viewModel.subGoalsScheduled(on: calendarDate)
            if !completed.isEmpty || !scheduled.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text(calendarDate.formatted(.dateTime.day().month(.wide).year()))
                        .font(.custom(DesignSystem.Fonts.interSemiBold, size: 16))
                        .foregroundColor(.white)

                    ForEach(completed) { sub in
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(DesignSystem.Colors.accentGreen)
                                .font(.system(size: 16))
                            Text(sub.title)
                                .font(.custom(DesignSystem.Fonts.interRegular, size: 15))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 4)
                    }

                    ForEach(scheduled.filter { s in !completed.contains(where: { $0.id == s.id }) }) { sub in
                        HStack(spacing: 10) {
                            Image(systemName: "calendar")
                                .foregroundColor(DesignSystem.Colors.termInputBorder)
                                .font(.system(size: 16))
                            Text(sub.title)
                                .font(.custom(DesignSystem.Fonts.interRegular, size: 15))
                                .foregroundColor(.white)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                Text("No subgoals on this day")
                    .font(.custom(DesignSystem.Fonts.interRegular, size: 14))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.top, 4)
            }
        }
        .padding(.top, 12)
    }
}

private struct ChecklistSubGoalRow: View {
    let subGoal: SubGoal
    var dateText: String
    var onToggle: () -> Void
    var onDelete: () -> Void
    var onEdit: () -> Void



    var body: some View {
        HStack(spacing: 10) {
            Text(dateText)
                .font(.custom(DesignSystem.Fonts.interRegular, size: 12))
                .foregroundColor(DesignSystem.Colors.subGoalText.opacity(0.8))
                .frame(width: 64, alignment: .leading)

            Text(subGoal.title)
                .font(.custom(DesignSystem.Fonts.interSemiBold, size: 16))
                .foregroundColor(DesignSystem.Colors.subGoalText)
                .lineLimit(1)

            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(DesignSystem.Colors.checkboxBg)
                    .frame(width: 24, height: 24)
                if subGoal.isCompleted {
                    Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(DesignSystem.Colors.accentGreen)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(DesignSystem.Radii.input)
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.Radii.input)
            .inset(by: 1)
            .stroke(DesignSystem.Colors.inputBorder, lineWidth: 1)
        )
        .contentShape(Rectangle())
        .swipeToReveal(
            revealWidth: DesignSystem.Swipe.subGoalRevealWidth,
            onEdit: onEdit,
            onDelete: onDelete,
            onTapped: onToggle
        )
        .clipped()
    }
}

private func subGoalDateText(_ subGoal: SubGoal) -> String {
    guard let date = subGoal.scheduledDate else { return "—" }
    return DesignSystem.Formatters.shortDate.string(from: date)
}

#Preview {
    GoalDetailView(goal: Goal(title: "Prepare for a marathon", targetDate: Date(), subGoals: [
        SubGoal(title: "Run 50 km", isCompleted: true, scheduledDate: Date()),
        SubGoal(title: "Buy sneakers", isCompleted: true, scheduledDate: Date()),
        SubGoal(title: "Competitions", isCompleted: false, scheduledDate: Date())
    ]))
    .environmentObject(Router())
    .environmentObject(GoalsStore())
}
