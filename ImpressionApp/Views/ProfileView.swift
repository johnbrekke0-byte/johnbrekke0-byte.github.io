import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var progress: UserProgress

    private var completed: Int { progress.completedLessons.count }
    private var total: Int { ImpressionCharacter.catalog.count }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Avatar + name
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .frame(width: 100, height: 100)
                            Text("🎭")
                                .font(.system(size: 50))
                        }
                        Text("Impressionist")
                            .font(.title2).bold()
                        Text("Level \(progress.level)")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 16)

                    // XP bar
                    VStack(spacing: 6) {
                        HStack {
                            Text("\(progress.xp) XP")
                                .font(.subheadline).bold()
                            Spacer()
                            Text("\(progress.xpToNextLevel) to next level")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule().fill(Color.gray.opacity(0.2))
                                Capsule()
                                    .fill(Color.yellow.gradient)
                                    .frame(width: geo.size.width * progress.xpProgress)
                            }
                        }
                        .frame(height: 10)
                    }
                    .padding(.horizontal)

                    // Stats grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                        StatCard(value: "\(progress.streak)🔥", label: "Day Streak")
                        StatCard(value: "\(completed)/\(total)", label: "Completed")
                        StatCard(value: "\(progress.xp)", label: "Total XP")
                    }
                    .padding(.horizontal)

                    // Best scores
                    if !progress.highScores.isEmpty {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Personal Bests")
                                .font(.headline)
                                .padding(.horizontal)
                                .padding(.bottom, 10)

                            ForEach(
                                progress.highScores.sorted { $0.value > $1.value }.prefix(10),
                                id: \.key
                            ) { name, score in
                                HStack {
                                    if let char = ImpressionCharacter.catalog.first(where: { $0.name == name }) {
                                        Text(char.emoji).frame(width: 28)
                                    }
                                    Text(name)
                                        .font(.subheadline)
                                    Spacer()
                                    Text("\(score)%")
                                        .font(.subheadline.monospacedDigit())
                                        .foregroundStyle(score >= 70 ? .green : .orange)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                Divider().padding(.leading, 44)
                            }
                        }
                        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal)
                    }

                    // Category completion
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Category Progress")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(CharacterCategory.allCases, id: \.self) { cat in
                            let pct = ProgressService.completionPercent(for: cat, progress: progress)
                            HStack {
                                Text(cat.emoji).frame(width: 28)
                                Text(cat.rawValue).font(.subheadline)
                                Spacer()
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule().fill(Color.gray.opacity(0.2))
                                        Capsule().fill(categoryColor(cat).gradient)
                                            .frame(width: geo.size.width * pct)
                                    }
                                }
                                .frame(width: 100, height: 8)
                                Text("\(Int(pct * 100))%")
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(.secondary)
                                    .frame(width: 32, alignment: .trailing)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Profile")
        }
    }

    private func categoryColor(_ cat: CharacterCategory) -> Color {
        switch cat {
        case .animated: return .purple
        case .celebrities: return .blue
        case .accents: return .green
        }
    }
}

struct StatCard: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.title2).bold()
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
    }
}
