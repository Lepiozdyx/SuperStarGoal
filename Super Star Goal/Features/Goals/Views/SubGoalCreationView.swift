import SwiftUI

struct SubGoalCreationView: View {
    let goal: Goal
    let subGoalToEdit: SubGoal?
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var goalsStore: GoalsStore
    @Environment(\.dismiss) private var dismiss

    @State private var subGoalTitle: String
    @State private var scheduledDate: Date
    @State private var showCalendar = false
    @FocusState private var isNameFocused: Bool

    init(goal: Goal, subGoalToEdit: SubGoal? = nil) {
        self.goal = goal
        self.subGoalToEdit = subGoalToEdit
        let initialDate = subGoalToEdit?.scheduledDate ?? goal.targetDate
        _subGoalTitle = State(initialValue: subGoalToEdit?.title ?? "")
        _scheduledDate = State(initialValue: initialDate)
    }

    private var isEditMode: Bool { subGoalToEdit != nil }

    var body: some View {
        VStack(spacing: 0) {
            DetailBackButton { isEditMode ? dismiss() : router.pop() }
                .padding(.bottom, 30)

            CreationFormLayout(
                title: $subGoalTitle,
                date: $scheduledDate,
                showCalendar: $showCalendar,
                isEditMode: isEditMode,
                placeholder: "Sub-goal name",
                onSave: save
            )
        }
        .screenBackground()

        .navigationBarBackButtonHidden(true)
    }



    private func save() {
        guard !subGoalTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let title = subGoalTitle.trimmingCharacters(in: .whitespaces)
        if let existing = subGoalToEdit, let idx = goal.subGoals.firstIndex(where: { $0.id == existing.id }) {
            var updatedGoal = goal
            updatedGoal.subGoals[idx].title = title
            updatedGoal.subGoals[idx].scheduledDate = scheduledDate
            goalsStore.update(updatedGoal)
            dismiss()
        } else {
            var updatedGoal = goal
            updatedGoal.subGoals.append(SubGoal(title: title, scheduledDate: scheduledDate))
            goalsStore.update(updatedGoal)
            router.pop()
        }
    }


}

#Preview("Create") {
    SubGoalCreationView(goal: Goal(title: "Test Goal", targetDate: Date()))
        .environmentObject(Router())
        .environmentObject(GoalsStore())
}

#Preview("Edit") {
    SubGoalCreationView(goal: Goal(title: "Test Goal", targetDate: Date()), subGoalToEdit: SubGoal(title: "Run 5k", scheduledDate: Date()))
        .environmentObject(Router())
        .environmentObject(GoalsStore())
}
