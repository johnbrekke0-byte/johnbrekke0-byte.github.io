import Foundation
import Combine

class UserProgress: ObservableObject {
    private static let storageKey = "user_progress_v1"

    @Published var xp: Int = 0
    @Published var streak: Int = 0
    @Published var lastPracticeDate: Date? = nil
    @Published var completedLessons: Set<String> = []
    @Published var highScores: [String: Int] = [:]

    var level: Int { max(1, xp / 100) }
    var xpToNextLevel: Int { ((level) * 100) - xp }
    var xpProgress: Double { Double(xp % 100) / 100.0 }

    init() { load() }

    func recordPractice(characterName: String, score: Int, difficulty: Difficulty) {
        let key = characterName
        let previousBest = highScores[key] ?? 0

        if score >= difficulty.requiredScore {
            completedLessons.insert(key)
        }

        if score > previousBest {
            highScores[key] = score
        }

        let earned = calculateXP(score: score, difficulty: difficulty, isNewBest: score > previousBest)
        xp += earned

        updateStreak()
        save()
    }

    func isUnlocked(_ character: ImpressionCharacter) -> Bool {
        xp >= character.unlockXP
    }

    func isCompleted(_ character: ImpressionCharacter) -> Bool {
        completedLessons.contains(character.name)
    }

    func bestScore(for character: ImpressionCharacter) -> Int? {
        highScores[character.name]
    }

    private func calculateXP(score: Int, difficulty: Difficulty, isNewBest: Bool) -> Int {
        let base = Int(Double(difficulty.xpReward) * Double(score) / 100.0)
        let bonus = isNewBest ? difficulty.xpReward / 2 : 0
        return base + bonus
    }

    private func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        if let last = lastPracticeDate {
            let lastDay = Calendar.current.startOfDay(for: last)
            let diff = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if diff == 1 {
                streak += 1
            } else if diff > 1 {
                streak = 1
            }
        } else {
            streak = 1
        }
        lastPracticeDate = Date()
    }

    // MARK: - Persistence

    private struct StorageModel: Codable {
        var xp: Int
        var streak: Int
        var lastPracticeDate: Date?
        var completedLessons: [String]
        var highScores: [String: Int]
    }

    func save() {
        let model = StorageModel(
            xp: xp,
            streak: streak,
            lastPracticeDate: lastPracticeDate,
            completedLessons: Array(completedLessons),
            highScores: highScores
        )
        if let data = try? JSONEncoder().encode(model) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.storageKey),
              let model = try? JSONDecoder().decode(StorageModel.self, from: data) else { return }
        xp = model.xp
        streak = model.streak
        lastPracticeDate = model.lastPracticeDate
        completedLessons = Set(model.completedLessons)
        highScores = model.highScores
    }
}
