import Foundation
import SwiftUI

struct SubGoal: Codable, Identifiable {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var completedAt: Date?
    var scheduledDate: Date?

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, completedAt: Date? = nil, scheduledDate: Date? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.completedAt = completedAt
        self.scheduledDate = scheduledDate
    }
}

struct Goal: Codable, Identifiable, Hashable {
    var id: UUID
    var title: String
    var targetDate: Date
    var subGoals: [SubGoal]
    var createdAt: Date
    var accentColorHex: String

    static let accentPalette: [String] = [
        "42E82E",  // green
        "FFC73B",  // yellow/orange
        "3DBCF6",  // blue
        "F06292",  // pink
        "AB47BC",  // purple
        "FF7043",  // deep orange
        "26C6DA",  // cyan
        "66BB6A",  // light green
    ]

    var progress: Double {
        guard !subGoals.isEmpty else { return 0 }
        let completed = subGoals.filter(\.isCompleted).count
        return Double(completed) / Double(subGoals.count)
    }

    var progressSubtitle: String {
        let pct = Int(progress * 100)
        return "Status: Progress \(pct)%"
    }

    var subGoalsSubtitle: String {
        let completed = subGoals.filter(\.isCompleted).count
        return "Subgoals completed: \(completed)/\(subGoals.count)"
    }

    var accentColor: Color {
        Color(hex: accentColorHex) ?? Color(red: 0.25, green: 0.86, blue: 0.18)
    }

    init(
        id: UUID = UUID(),
        title: String,
        targetDate: Date,
        subGoals: [SubGoal] = [],
        createdAt: Date = Date(),
        accentColorHex: String? = nil
    ) {
        self.id = id
        self.title = title
        self.targetDate = targetDate
        self.subGoals = subGoals
        self.createdAt = createdAt
        self.accentColorHex = accentColorHex ?? Goal.accentPalette.randomElement() ?? "42E82E"
    }
}

extension SubGoal: Hashable {
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: SubGoal, rhs: SubGoal) -> Bool { lhs.id == rhs.id }
}


extension Color {
    init?(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        guard cleaned.count == 6 else { return nil }
        var rgb: UInt64 = 0
        guard Scanner(string: cleaned).scanHexInt64(&rgb) else { return nil }
        self.init(
            red: Double((rgb >> 16) & 0xFF) / 255.0,
            green: Double((rgb >> 8) & 0xFF) / 255.0,
            blue: Double(rgb & 0xFF) / 255.0
        )
    }
}
