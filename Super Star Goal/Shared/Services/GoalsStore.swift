import Combine
import Foundation
import SwiftUI

@MainActor
final class GoalsStore: ObservableObject {
    @Published private(set) var goals: [Goal] = []
    private let storage = GoalsStorageService()

    init() {
        goals = storage.load()
    }

    func add(_ goal: Goal) {
        var updatedGoals = goals
        updatedGoals.append(goal)
        apply(updatedGoals)
    }

    func update(_ goal: Goal) {
        guard let i = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        var updatedGoals = goals
        updatedGoals[i] = goal
        apply(updatedGoals)
    }

    func delete(_ goal: Goal) {
        let updatedGoals = goals.filter { $0.id != goal.id }
        apply(updatedGoals)
    }

    func goal(byId id: UUID) -> Goal? {
        goals.first { $0.id == id }
    }

    private func apply(_ updatedGoals: [Goal]) {
        goals = updatedGoals
        storage.save(updatedGoals)
    }
}
