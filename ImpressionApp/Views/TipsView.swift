import SwiftUI

struct TipsView: View {
    let character: ImpressionCharacter
    let onContinue: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Character hero
                VStack(spacing: 12) {
                    Text(character.emoji)
                        .font(.system(size: 80))
                    Text(character.name)
                        .font(.largeTitle).bold()
                    DifficultyBadge(difficulty: character.difficulty)
                }
                .padding(.top, 24)

                // Voice traits
                VStack(alignment: .leading, spacing: 0) {
                    Text("Voice Key")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.bottom, 10)

                    ForEach(character.voiceTraits) { trait in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 12) {
                                Image(systemName: trait.icon)
                                    .frame(width: 28)
                                    .foregroundStyle(.accentColor)
                                    .font(.title3)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(trait.name)
                                        .font(.subheadline).bold()
                                    Text(trait.description)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            Divider().padding(.leading, 52)
                        }
                    }
                }
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)

                // Practice phrases preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("You'll Practice")
                        .font(.headline)
                    ForEach(character.phrases) { phrase in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "quote.bubble")
                                .foregroundStyle(.secondary)
                            Text(phrase.text)
                                .font(.subheadline)
                                .italic()
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)

                Button(action: onContinue) {
                    Text("Let's Listen")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
        }
    }
}

struct DifficultyBadge: View {
    let difficulty: Difficulty

    var body: some View {
        Text(difficulty.rawValue)
            .font(.caption).bold()
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(badgeColor.opacity(0.15), in: Capsule())
            .foregroundStyle(badgeColor)
    }

    private var badgeColor: Color {
        switch difficulty {
        case .beginner: return .green
        case .intermediate: return .orange
        case .advanced: return .red
        }
    }
}
