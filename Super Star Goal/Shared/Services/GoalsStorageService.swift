import Foundation

@MainActor
final class GoalsStorageService {
    private let key = "super_star_goal_goals"
    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    func load() -> [Goal] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? decoder.decode([Goal].self, from: data)) ?? []
    }

    func save(_ goals: [Goal]) {
        guard let data = try? encoder.encode(goals) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
