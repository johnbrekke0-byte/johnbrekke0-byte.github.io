import Foundation

// Thin façade over UserDefaults; all state lives in UserProgress (ObservableObject).
// This handles one-off queries that don't need reactive binding.
struct ProgressService {

    static func streakIsAtRisk() -> Bool {
        guard let defaults = UserDefaults.standard.data(forKey: "user_progress_v1"),
              let dict = try? JSONDecoder().decode([String: AnyCodable].self, from: defaults)
        else { return false }
        return false
    }

    static func totalCharactersCompleted(progress: UserProgress) -> Int {
        progress.completedLessons.count
    }

    static func completionPercent(for category: CharacterCategory, progress: UserProgress) -> Double {
        let chars = ImpressionCharacter.catalog.filter { $0.category == category }
        guard !chars.isEmpty else { return 0 }
        let done = chars.filter { progress.isCompleted($0) }.count
        return Double(done) / Double(chars.count)
    }

    static func nextUnlockedCharacter(progress: UserProgress) -> ImpressionCharacter? {
        ImpressionCharacter.catalog
            .filter { progress.isUnlocked($0) && !progress.isCompleted($0) }
            .sorted { $0.unlockXP < $1.unlockXP }
            .first
    }
}

// Minimal wrapper to decode arbitrary JSON values — used only for the streak-at-risk check.
private struct AnyCodable: Codable {
    init(from decoder: Decoder) throws {
        _ = try decoder.singleValueContainer()
    }
    func encode(to encoder: Encoder) throws {}
}
