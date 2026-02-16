import SwiftUI

struct GoalCreationView: View {
    let goalToEdit: Goal?
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var goalsStore: GoalsStore
    @Environment(\.dismiss) private var dismiss

    @State private var goalTitle: String
    @State private var targetDate: Date
    @State private var showCalendar = false
    @FocusState private var isNameFocused: Bool

    init(goalToEdit: Goal? = nil) {
        self.goalToEdit = goalToEdit
        _goalTitle = State(initialValue: goalToEdit?.title ?? "")
        _targetDate = State(initialValue: goalToEdit?.targetDate ?? Date())
    }

    private var isEditMode: Bool { goalToEdit != nil }

    var body: some View {
        VStack(spacing: 0) {
            DetailBackButton { isEditMode ? dismiss() : router.pop() }
                .padding(.bottom, 30)

            CreationFormLayout(
                title: $goalTitle,
                date: $targetDate,
                showCalendar: $showCalendar,
                isEditMode: isEditMode,
                placeholder: "Goal name",
                onSave: save
            )
        }
        .screenBackground()

        .navigationBarBackButtonHidden(true)
    }

    private func save() {
        guard !goalTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        if let existing = goalToEdit {
            var updated = existing
            updated.title = goalTitle.trimmingCharacters(in: .whitespaces)
            updated.targetDate = targetDate
            goalsStore.update(updated)
            dismiss()
        } else {
            goalsStore.add(Goal(title: goalTitle.trimmingCharacters(in: .whitespaces), targetDate: targetDate))
            router.pop()
        }
    }


}

#Preview("Create") {
    GoalCreationView()
        .environmentObject(Router())
        .environmentObject(GoalsStore())
}

#Preview("Edit") {
    GoalCreationView(goalToEdit: Goal(title: "Test Goal", targetDate: Date()))
        .environmentObject(Router())
        .environmentObject(GoalsStore())
}
