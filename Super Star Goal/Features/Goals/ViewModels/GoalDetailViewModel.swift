import Combine
import Foundation
import SwiftUI

@MainActor
final class GoalDetailViewModel: ObservableObject {
    @Published var goal: Goal
    private let store: GoalsStore
    private var cancellable: AnyCancellable?

    init(goal: Goal, store: GoalsStore) {
        self.goal = goal
        self.store = store

        cancellable = store.$goals
            .compactMap { $0.first(where: { $0.id == goal.id }) }
            .receive(on: RunLoop.main)
            .assign(to: \.goal, on: self)
    }

    func toggleSubGoal(_ subGoal: SubGoal) {
        guard let i = goal.subGoals.firstIndex(where: { $0.id == subGoal.id }) else { return }
        var updated = goal
        updated.subGoals[i].isCompleted.toggle()
        updated.subGoals[i].completedAt = updated.subGoals[i].isCompleted ? Date() : nil
        goal = updated
        store.update(goal)
    }

    func addSubGoal(title: String) {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let sub = SubGoal(title: title)
        goal.subGoals.append(sub)
        store.update(goal)
    }

    func deleteSubGoal(_ subGoal: SubGoal) {
        var updated = goal
        updated.subGoals.removeAll { $0.id == subGoal.id }
        goal = updated
        store.update(updated)
    }

    func deleteGoal() {
        store.delete(goal)
    }

    var completedSubGoals: [SubGoal] {
        goal.subGoals.filter { $0.isCompleted && $0.completedAt != nil }
    }

    var completedDateComponents: Set<DateComponents> {
        let cal = Calendar.current
        var set = Set<DateComponents>()
        for sub in completedSubGoals {
            if let date = sub.completedAt {
                set.insert(cal.dateComponents([.year, .month, .day], from: date))
            }
        }
        return set
    }

    var scheduledDateComponents: Set<DateComponents> {
        let cal = Calendar.current
        var set = Set<DateComponents>()
        for sub in goal.subGoals {
            if let date = sub.scheduledDate {
                set.insert(cal.dateComponents([.year, .month, .day], from: date))
            }
        }
        return set
    }

    var allEventDateComponents: Set<DateComponents> {
        completedDateComponents.union(scheduledDateComponents)
    }

    func subGoalsCompleted(on date: Date) -> [SubGoal] {
        let cal = Calendar.current
        return completedSubGoals.filter { sub in
            guard let completedAt = sub.completedAt else { return false }
            return cal.isDate(completedAt, inSameDayAs: date)
        }
    }

    func subGoalsScheduled(on date: Date) -> [SubGoal] {
        let cal = Calendar.current
        return goal.subGoals.filter { sub in
            guard let scheduled = sub.scheduledDate else { return false }
            return cal.isDate(scheduled, inSameDayAs: date)
        }
    }
}
