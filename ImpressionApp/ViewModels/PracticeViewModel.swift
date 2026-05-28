import Foundation
import SwiftUI

enum PracticePhase: Equatable {
    case tips
    case listen
    case record
    case analyzing
    case result(score: Int)
}

@MainActor
class PracticeViewModel: ObservableObject {
    @Published var phase: PracticePhase = .tips
    @Published var currentPhraseIndex: Int = 0
    @Published var analysisResult: AnalysisResult? = nil
    @Published var xpEarned: Int = 0
    @Published var isNewBest: Bool = false

    let character: ImpressionCharacter
    let audioService: AudioRecordingService
    private let analysisService = VoiceAnalysisService()

    init(character: ImpressionCharacter) {
        self.character = character
        self.audioService = AudioRecordingService()
    }

    var currentPhrase: PracticePhrase {
        character.phrases[min(currentPhraseIndex, character.phrases.count - 1)]
    }

    func advance() {
        switch phase {
        case .tips:   phase = .listen
        case .listen: phase = .record
        default: break
        }
    }

    func startRecording() async {
        await audioService.requestPermissionAndRecord()
    }

    func stopAndAnalyze(progress: UserProgress) async {
        audioService.stopRecording()
        phase = .analyzing

        guard let url = audioService.recordingURL else {
            phase = .result(score: 0)
            return
        }

        let result = await analysisService.analyze(recordingURL: url, character: character)
        analysisResult = result

        let previousBest = progress.highScores[character.name] ?? 0
        isNewBest = result.overallScore > previousBest

        progress.recordPractice(
            characterName: character.name,
            score: result.overallScore,
            difficulty: character.difficulty
        )

        xpEarned = Int(Double(character.difficulty.xpReward) * Double(result.overallScore) / 100.0)
        phase = .result(score: result.overallScore)
    }

    func tryAgain() {
        audioService.reset()
        analysisResult = nil
        phase = .record
    }

    func nextPhrase() {
        if currentPhraseIndex < character.phrases.count - 1 {
            currentPhraseIndex += 1
            audioService.reset()
            analysisResult = nil
            phase = .record
        }
    }
}
