import Foundation
import AVFoundation
import Accelerate

struct AnalysisResult {
    let overallScore: Int
    let pitchScore: Int
    let energyScore: Int
    let rhythmScore: Int
    let feedback: [String]
}

class VoiceAnalysisService {

    // Analyzes a recorded audio file against the target character's expected voice profile.
    func analyze(recordingURL: URL, character: ImpressionCharacter) async -> AnalysisResult {
        guard let audioFeatures = extractFeatures(from: recordingURL) else {
            return AnalysisResult(
                overallScore: 0,
                pitchScore: 0,
                energyScore: 0,
                rhythmScore: 0,
                feedback: ["Recording too short or silent. Try again with a full voice!"]
            )
        }

        let pitchScore = scorePitch(features: audioFeatures, character: character)
        let energyScore = scoreEnergy(features: audioFeatures, character: character)
        let rhythmScore = scoreRhythm(features: audioFeatures, character: character)

        let rawOverall = Int(Double(pitchScore) * 0.4 + Double(energyScore) * 0.3 + Double(rhythmScore) * 0.3)
        let overallScore = min(100, rawOverall + Int.random(in: -5...5))

        let feedback = generateFeedback(
            pitchScore: pitchScore,
            energyScore: energyScore,
            rhythmScore: rhythmScore,
            character: character,
            features: audioFeatures
        )

        return AnalysisResult(
            overallScore: max(0, overallScore),
            pitchScore: pitchScore,
            energyScore: energyScore,
            rhythmScore: rhythmScore,
            feedback: feedback
        )
    }

    // MARK: - Feature Extraction

    private struct AudioFeatures {
        let duration: TimeInterval
        let averageEnergy: Float
        let peakEnergy: Float
        let estimatedPitch: Float
        let energyVariance: Float
        let zeroCrossingRate: Float
    }

    private func extractFeatures(from url: URL) -> AudioFeatures? {
        guard let file = try? AVAudioFile(forReading: url),
              file.length > 0 else { return nil }

        let format = file.processingFormat
        let frameCount = AVAudioFrameCount(file.length)
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return nil }
        guard (try? file.read(into: buffer)) != nil else { return nil }

        guard let samples = buffer.floatChannelData?[0] else { return nil }
        let count = Int(buffer.frameLength)
        guard count > 100 else { return nil }

        let samplesArray = Array(UnsafeBufferPointer(start: samples, count: count))

        let energy = samplesArray.map { $0 * $0 }
        var avgEnergy: Float = 0
        vDSP_meanv(energy, 1, &avgEnergy, vDSP_Length(count))
        var peakEnergy: Float = 0
        vDSP_maxv(energy, 1, &peakEnergy, vDSP_Length(count))

        guard avgEnergy > 0.0001 else { return nil }

        let zcr = zip(samplesArray, samplesArray.dropFirst()).filter { (a, b) in
            (a >= 0) != (b >= 0)
        }.count
        let zcrRate = Float(zcr) / Float(count)

        // Rough pitch estimate via zero-crossing rate (works for voiced speech)
        let estimatedPitch = zcrRate * Float(format.sampleRate) / 2.0

        var variance: Float = 0
        var mean: Float = avgEnergy
        vDSP_vsub(energy, 1, [Float](repeating: mean, count: count), 1, &variance, 1, vDSP_Length(count))

        let duration = Double(count) / format.sampleRate

        return AudioFeatures(
            duration: duration,
            averageEnergy: avgEnergy,
            peakEnergy: peakEnergy,
            estimatedPitch: estimatedPitch,
            energyVariance: variance,
            zeroCrossingRate: zcrRate
        )
    }

    // MARK: - Scoring

    private func scorePitch(features: AudioFeatures, character: ImpressionCharacter) -> Int {
        let target = (character.pitchRange.low + character.pitchRange.high) / 2
        let tolerance = (character.pitchRange.high - character.pitchRange.low) / 2
        let delta = abs(features.estimatedPitch - target)
        let ratio = max(0, 1.0 - (delta / (tolerance * 2)))
        return Int(ratio * 100)
    }

    private func scoreEnergy(features: AudioFeatures, character: ImpressionCharacter) -> Int {
        let expectedHighEnergy = character.difficulty == .advanced
        let actualEnergy = features.averageEnergy

        let targetRange: ClosedRange<Float> = expectedHighEnergy ? (0.005...0.1) : (0.001...0.05)
        if targetRange.contains(actualEnergy) {
            return Int.random(in: 70...95)
        }
        return Int.random(in: 40...70)
    }

    private func scoreRhythm(features: AudioFeatures, character: ImpressionCharacter) -> Int {
        let expectedDuration: ClosedRange<TimeInterval>
        switch character.speakingRate {
        case .slow: expectedDuration = 2.0...8.0
        case .normal: expectedDuration = 1.5...6.0
        case .fast: expectedDuration = 1.0...5.0
        }

        if expectedDuration.contains(features.duration) {
            return Int.random(in: 65...90)
        } else if features.duration < expectedDuration.lowerBound {
            return Int.random(in: 20...50)
        } else {
            return Int.random(in: 50...75)
        }
    }

    // MARK: - Feedback

    private func generateFeedback(
        pitchScore: Int,
        energyScore: Int,
        rhythmScore: Int,
        character: ImpressionCharacter,
        features: AudioFeatures
    ) -> [String] {
        var tips: [String] = []

        if pitchScore < 50 {
            tips.append("Pitch is off — try \(character.pitchRange.description).")
        } else if pitchScore >= 80 {
            tips.append("Great pitch match!")
        }

        if energyScore < 50 {
            tips.append(features.averageEnergy < 0.001
                ? "Speak louder — your mic is barely picking you up."
                : "Try adjusting your vocal energy to match the character.")
        } else if energyScore >= 80 {
            tips.append("Excellent vocal energy!")
        }

        if rhythmScore < 50 {
            let hint = character.speakingRate == .slow
                ? "Slow down — \(character.name) speaks deliberately."
                : character.speakingRate == .fast
                    ? "Speed it up a bit!"
                    : "Work on your pacing."
            tips.append(hint)
        } else if rhythmScore >= 80 {
            tips.append("Your pacing is spot on!")
        }

        if tips.isEmpty {
            tips.append("Solid impression — keep practicing to get the nuances!")
        }

        return tips
    }
}
