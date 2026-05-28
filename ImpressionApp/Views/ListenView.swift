import SwiftUI
import AVFoundation

// Plays a synthesized reference of the phrase using AVSpeechSynthesizer.
// In production, swap speechSynth for pre-recorded reference audio files.
struct ListenView: View {
    let character: ImpressionCharacter
    let currentPhrase: PracticePhrase
    let onContinue: () -> Void

    @State private var isPlaying = false
    @State private var playCount = 0
    private let synth = AVSpeechSynthesizer()

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("Listen carefully")
                .font(.title2).bold()

            Text(character.emoji)
                .font(.system(size: 64))

            // Phrase card
            VStack(spacing: 12) {
                Text("\"\(currentPhrase.text)\"")
                    .font(.title3)
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding()

                if let hint = currentPhrase.hint {
                    Text("Tip: \(hint)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)

            // Play button
            Button(action: playReference) {
                HStack(spacing: 10) {
                    Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                        .font(.system(size: 44))
                    Text(isPlaying ? "Playing..." : playCount == 0 ? "Play Reference" : "Play Again")
                        .font(.headline)
                }
                .foregroundStyle(isPlaying ? .orange : .accentColor)
            }

            if playCount > 0 {
                Text("Heard \(playCount)x — ready when you are!")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: onContinue) {
                Text("I'm Ready to Record")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(playCount > 0 ? Color.accentColor : Color.gray.opacity(0.3))
                    .foregroundStyle(playCount > 0 ? .white : .secondary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(playCount == 0)
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
    }

    private func playReference() {
        if isPlaying {
            synth.stopSpeaking(at: .immediate)
            isPlaying = false
            return
        }
        let utterance = AVSpeechUtterance(string: currentPhrase.text)
        utterance.voice = voiceForCharacter
        utterance.rate = rateForCharacter
        utterance.pitchMultiplier = pitchForCharacter

        isPlaying = true
        playCount += 1

        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("AVSpeechSynthesizerDidFinishSpeechUtterance"),
            object: nil, queue: .main
        ) { _ in isPlaying = false }

        synth.speak(utterance)

        // Fallback: reset isPlaying after estimated duration
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(currentPhrase.text.count) * 0.07 + 1.5) {
            isPlaying = false
        }
    }

    private var voiceForCharacter: AVSpeechSynthesisVoice? {
        switch character.category {
        case .accents:
            switch character.name {
            case "British RP": return AVSpeechSynthesisVoice(language: "en-GB")
            case "Australian": return AVSpeechSynthesisVoice(language: "en-AU")
            default: return AVSpeechSynthesisVoice(language: "en-US")
            }
        default: return AVSpeechSynthesisVoice(language: "en-US")
        }
    }

    private var rateForCharacter: Float {
        switch character.speakingRate {
        case .slow: return 0.38
        case .normal: return 0.5
        case .fast: return 0.62
        }
    }

    private var pitchForCharacter: Float {
        let mid = (character.pitchRange.low + character.pitchRange.high) / 2
        return max(0.5, min(2.0, mid / 200.0))
    }
}
