import SwiftUI

struct RecordView: View {
    @ObservedObject var vm: PracticeViewModel
    @EnvironmentObject var progress: UserProgress

    private var audioService: AudioRecordingService { vm.audioService }

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Text("Your turn")
                .font(.title2).bold()

            // Phrase to say
            Text("\"\(vm.currentPhrase.text)\"")
                .font(.title3)
                .italic()
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // Waveform
            WaveformView(level: audioService.meteringLevel, color: isRecording ? .red : .gray.opacity(0.4))
                .frame(height: 60)
                .padding(.horizontal)

            // Timer
            if isRecording {
                Text(String(format: "%.1fs", audioService.recordingDuration))
                    .font(.title3.monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            // Error display
            if case .error(let msg) = audioService.state {
                Text(msg)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            // Main record / stop button
            Button(action: handleMainButton) {
                ZStack {
                    Circle()
                        .fill(isRecording ? Color.red : Color.accentColor)
                        .frame(width: 88, height: 88)
                        .shadow(color: (isRecording ? Color.red : Color.accentColor).opacity(0.4), radius: 12)

                    if isRecording {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.white)
                            .frame(width: 28, height: 28)
                    } else {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 34))
                            .foregroundStyle(.white)
                    }
                }
                .scaleEffect(isRecording ? 1.12 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isRecording)
            }

            // Playback + re-record after stopping
            if case .stopped = audioService.state {
                HStack(spacing: 20) {
                    Button(action: { audioService.playBack() }) {
                        Label("Listen back", systemImage: "play.circle")
                            .font(.subheadline)
                    }

                    Button(action: { audioService.reset() }) {
                        Label("Re-record", systemImage: "arrow.counterclockwise")
                            .font(.subheadline)
                    }
                    .foregroundStyle(.secondary)
                }

                Button(action: {
                    Task { await vm.stopAndAnalyze(progress: progress) }
                }) {
                    Text("Analyze My Impression")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)
            }

            if case .playing = audioService.state {
                Button(action: { audioService.stopPlayback() }) {
                    Label("Stop", systemImage: "stop.circle")
                }
                .foregroundStyle(.orange)
            }

            Spacer()
        }
    }

    private var isRecording: Bool {
        if case .recording = audioService.state { return true }
        return false
    }

    private func handleMainButton() {
        if isRecording {
            audioService.stopRecording()
        } else if case .idle = audioService.state {
            Task { await vm.startRecording() }
        } else {
            audioService.reset()
        }
    }
}

struct AnalyzingView: View {
    @State private var dots = ""
    @State private var timer: Timer?

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "waveform.and.magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.accentColor)
                .symbolEffect(.pulse)
            Text("Analyzing\(dots)")
                .font(.title2).bold()
            Text("Comparing pitch, energy, and rhythm...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                dots = dots.count < 3 ? dots + "." : ""
            }
        }
        .onDisappear { timer?.invalidate() }
    }
}
