import Foundation
import AVFoundation

enum RecordingState {
    case idle, requesting, recording, stopped, playing, error(String)
}

@MainActor
class AudioRecordingService: NSObject, ObservableObject {
    @Published var state: RecordingState = .idle
    @Published var recordingDuration: TimeInterval = 0
    @Published var meteringLevel: Float = 0

    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var meteringTimer: Timer?
    private var durationTimer: Timer?

    var recordingURL: URL? {
        FileManager.default.temporaryDirectory.appendingPathComponent("impression_recording.m4a")
    }

    func requestPermissionAndRecord() async {
        state = .requesting
        let granted = await AVAudioApplication.requestRecordPermission()
        if granted {
            startRecording()
        } else {
            state = .error("Microphone access denied. Enable it in Settings.")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        stopTimers()
        state = .stopped
    }

    func playBack() {
        guard let url = recordingURL, FileManager.default.fileExists(atPath: url.path) else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            state = .playing
        } catch {
            state = .error("Playback failed: \(error.localizedDescription)")
        }
    }

    func stopPlayback() {
        audioPlayer?.stop()
        state = .stopped
    }

    func reset() {
        audioRecorder?.stop()
        audioPlayer?.stop()
        stopTimers()
        if let url = recordingURL {
            try? FileManager.default.removeItem(at: url)
        }
        recordingDuration = 0
        meteringLevel = 0
        state = .idle
    }

    private func startRecording() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)
            try session.setActive(true)

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            guard let url = recordingURL else { return }
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()

            state = .recording
            recordingDuration = 0
            startTimers()
        } catch {
            state = .error("Recording failed: \(error.localizedDescription)")
        }
    }

    private func startTimers() {
        meteringTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            self?.audioRecorder?.updateMeters()
            let level = self?.audioRecorder?.averagePower(forChannel: 0) ?? -60
            let normalized = max(0, (level + 60) / 60)
            Task { @MainActor [weak self] in
                self?.meteringLevel = normalized
            }
        }
        durationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.recordingDuration = self?.audioRecorder?.currentTime ?? 0
            }
        }
    }

    private func stopTimers() {
        meteringTimer?.invalidate()
        meteringTimer = nil
        durationTimer?.invalidate()
        durationTimer = nil
    }
}

extension AudioRecordingService: AVAudioRecorderDelegate {
    nonisolated func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        Task { @MainActor in
            if !flag { self.state = .error("Recording ended unexpectedly") }
        }
    }
}

extension AudioRecordingService: AVAudioPlayerDelegate {
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in
            self.state = .stopped
        }
    }
}
