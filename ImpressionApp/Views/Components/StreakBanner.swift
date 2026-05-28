import SwiftUI

struct StreakBanner: View {
    let streak: Int
    let xp: Int
    let level: Int
    let xpProgress: Double

    var body: some View {
        HStack(spacing: 16) {
            // Streak
            HStack(spacing: 6) {
                Text("🔥")
                    .font(.title2)
                VStack(alignment: .leading, spacing: 0) {
                    Text("\(streak)")
                        .font(.title3).bold()
                    Text("streak")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.orange.opacity(0.12), in: Capsule())

            Spacer()

            // Level + XP
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .font(.caption)
                    Text("Level \(level)")
                        .font(.subheadline).bold()
                    Text("· \(xp) XP")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                        Capsule()
                            .fill(Color.yellow.gradient)
                            .frame(width: geo.size.width * xpProgress)
                    }
                }
                .frame(width: 120, height: 6)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.regularMaterial)
    }
}
