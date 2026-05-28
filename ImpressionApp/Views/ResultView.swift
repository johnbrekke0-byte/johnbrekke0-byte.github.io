import SwiftUI

struct ResultView: View {
    let character: ImpressionCharacter
    let result: AnalysisResult
    let score: Int
    let xpEarned: Int
    let isNewBest: Bool
    let hasNextPhrase: Bool
    let onTryAgain: () -> Void
    let onNextPhrase: () -> Void
    let onDone: () -> Void

    @State private var animatedScore: Int = 0
    @State private var showDetails = false

    private var passed: Bool { score >= character.difficulty.requiredScore }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Header
                VStack(spacing: 8) {
                    Text(passed ? "🎉" : "💪")
                        .font(.system(size: 56))
                    Text(passed ? "Nailed it!" : "Keep practicing!")
                        .font(.title2).bold()
                    if isNewBest {
                        Text("New personal best!")
                            .font(.subheadline)
                            .foregroundStyle(.yellow)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.yellow.opacity(0.15), in: Capsule())
                    }
                }
                .padding(.top, 24)

                // Score ring
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 14)
                        .frame(width: 140, height: 140)
                    Circle()
                        .trim(from: 0, to: Double(animatedScore) / 100.0)
                        .stroke(scoreColor.gradient, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 140, height: 140)
                    VStack(spacing: 2) {
                        Text("\(animatedScore)")
                            .font(.system(size: 44, weight: .bold, design: .rounded))
                        Text("/ 100")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .onAppear {
                    withAnimation(.easeOut(duration: 1.2)) {
                        animatedScore = score
                    }
                }

                // XP earned
                HStack(spacing: 8) {
                    Image(systemName: "star.fill").foregroundStyle(.yellow)
                    Text("+\(xpEarned) XP earned")
                        .font(.headline)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.yellow.opacity(0.12), in: Capsule())

                // Score breakdown
                VStack(spacing: 0) {
                    ScoreRow(label: "Pitch", icon: "waveform", score: result.pitchScore)
                    Divider().padding(.leading, 44)
                    ScoreRow(label: "Energy", icon: "speaker.wave.2", score: result.energyScore)
                    Divider().padding(.leading, 44)
                    ScoreRow(label: "Rhythm", icon: "metronome", score: result.rhythmScore)
                }
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)

                // Feedback tips
                VStack(alignment: .leading, spacing: 10) {
                    Text("Feedback")
                        .font(.headline)
                    ForEach(result.feedback, id: \.self) { tip in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundStyle(.yellow)
                                .font(.caption)
                                .padding(.top, 2)
                            Text(tip)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal)

                // Actions
                VStack(spacing: 12) {
                    if hasNextPhrase {
                        Button(action: onNextPhrase) {
                            Text("Next Phrase →")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .padding(.horizontal)
                    }

                    HStack(spacing: 12) {
                        Button(action: onTryAgain) {
                            Label("Try Again", systemImage: "arrow.counterclockwise")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }

                        Button(action: onDone) {
                            Text(passed ? "Done ✓" : "Quit")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
        }
    }

    private var scoreColor: Color {
        switch score {
        case 80...100: return .green
        case 60..<80:  return .yellow
        default:       return .red
        }
    }
}

struct ScoreRow: View {
    let label: String
    let icon: String
    let score: Int

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 28)
                .foregroundStyle(.secondary)
            Text(label)
                .font(.subheadline)
            Spacer()
            BarScore(score: score)
            Text("\(score)")
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(.secondary)
                .frame(width: 32, alignment: .trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}

struct BarScore: View {
    let score: Int

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.gray.opacity(0.2))
                Capsule()
                    .fill(barColor.gradient)
                    .frame(width: geo.size.width * Double(score) / 100.0)
            }
        }
        .frame(width: 80, height: 8)
    }

    private var barColor: Color {
        switch score {
        case 80...100: return .green
        case 60..<80: return .yellow
        default: return .red
        }
    }
}
