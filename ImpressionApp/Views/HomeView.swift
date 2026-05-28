import SwiftUI

struct HomeView: View {
    @EnvironmentObject var progress: UserProgress
    @State private var selectedCharacter: ImpressionCharacter? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    StreakBanner(
                        streak: progress.streak,
                        xp: progress.xp,
                        level: progress.level,
                        xpProgress: progress.xpProgress
                    )

                    VStack(spacing: 28) {
                        ForEach(CharacterCategory.allCases, id: \.self) { category in
                            CategorySection(
                                category: category,
                                characters: ImpressionCharacter.catalog.filter { $0.category == category },
                                progress: progress,
                                onSelect: { selectedCharacter = $0 }
                            )
                        }
                    }
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("ImpreSSion")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedCharacter) { character in
                PracticeRootView(character: character)
                    .environmentObject(progress)
            }
        }
    }
}

struct CategorySection: View {
    let category: CharacterCategory
    let characters: [ImpressionCharacter]
    let progress: UserProgress
    let onSelect: (ImpressionCharacter) -> Void

    var completionPercent: Double {
        ProgressService.completionPercent(for: category, progress: progress)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(category.emoji)
                    .font(.title2)
                Text(category.rawValue)
                    .font(.title3).bold()
                Spacer()
                Text("\(Int(completionPercent * 100))%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)

            // Progress bar for category
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.gray.opacity(0.2))
                    Capsule()
                        .fill(categoryColor.gradient)
                        .frame(width: geo.size.width * completionPercent)
                }
            }
            .frame(height: 4)
            .padding(.horizontal)

            // Character grid
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90, maximum: 110), spacing: 12)], spacing: 16) {
                ForEach(characters) { character in
                    CharacterCard(
                        character: character,
                        isUnlocked: progress.isUnlocked(character),
                        isCompleted: progress.isCompleted(character),
                        bestScore: progress.bestScore(for: character),
                        onTap: {
                            if progress.isUnlocked(character) {
                                onSelect(character)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }

    private var categoryColor: Color {
        switch category {
        case .animated: return .purple
        case .celebrities: return .blue
        case .accents: return .green
        }
    }
}
