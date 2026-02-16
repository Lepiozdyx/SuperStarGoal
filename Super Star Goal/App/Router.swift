import Combine
import SwiftUI

enum AppRoute: Hashable {
    case goalDetail(Goal)
    case goalCreation
    case goalEdit(Goal)
    case subGoalCreation(Goal)
    case calendarDayDetail(Date)
}

@MainActor
final class Router: ObservableObject {
    @Published var path = NavigationPath()

    func showCreation() {
        path.append(AppRoute.goalCreation)
    }

    func showGoalEdit(goal: Goal) {
        path.append(AppRoute.goalEdit(goal))
    }

    func showDetail(goal: Goal) {
        path.append(AppRoute.goalDetail(goal))
    }

    func showSubGoalCreation(goal: Goal) {
        path.append(AppRoute.subGoalCreation(goal))
    }

    func showCalendarDayDetail(date: Date) {
        path.append(AppRoute.calendarDayDetail(date))
    }

    func popToRoot() {
        path = NavigationPath()
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}
