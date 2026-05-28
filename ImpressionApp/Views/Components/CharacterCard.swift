import SwiftUI

struct CharacterCard: View {
    let character: ImpressionCharacter
    let isUnlocked: Bool
    let isCompleted: Bool
    let bestScore: Int?
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(cardBackground)
                        .frame(width: 70, height: 70)
                    Text(character.emoji)
                        .font(.system(size: 36))
                    if !isUnlocked {
                        Circle()
                            .fill(Color.black.opacity(0.55))
                            .frame(width: 70, height: 70)
                        Image(systemName: "lock.fill")
                            .foregroundStyle(.white)
                            .font(.title2)
                    } else if isCompleted {
                        Circle()
                            .strokeBorder(Color.yellow, lineWidth: 3)
                            .frame(width: 70, height: 70)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.yellow)
                                    .background(Circle().fill(.black))
                                    .font(.system(size: 20))
                                    .offset(x: 4, y: 4)
                            }
                        }
                        .frame(width: 70, height: 70)
                    }
                }

                Text(character.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundStyle(isUnlocked ? .primary : .secondary)
                    .frame(width: 80)

                if isUnlocked, let score = bestScore {
                    Text("\(score)%")
                        .font(.caption2)
                        .foregroundStyle(score >= character.difficulty.requiredScore ? .green : .orange)
                } else if !isUnlocked {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.caption2)
                        Text("\(character.unlockXP) XP")
                            .font(.caption2)
                    }
                    .foregroundStyle(.secondary)
                } else {
                    DifficultyDots(difficulty: character.difficulty)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var cardBackground: Color {
        switch character.category {
        case .animated:    return Color.purple.opacity(0.15)
        case .celebrities: return Color.blue.opacity(0.15)
        case .accents:     return Color.green.opacity(0.15)
        }
    }
}

struct DifficultyDots: View {
    let difficulty: Difficulty

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(i < filledCount ? dotColor : Color.gray.opacity(0.3))
                    .frame(width: 6, height: 6)
            }
        }
    }

    private var filledCount: Int {
        switch difficulty {
        case .beginner: return 1
        case .intermediate: return 2
        case .advanced: return 3
        }
    }

    private var dotColor: Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}
