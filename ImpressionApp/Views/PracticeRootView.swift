import SwiftUI

// Orchestrates the multi-step practice flow: Tips → Listen → Record → Result
struct PracticeRootView: View {
    @EnvironmentObject var progress: UserProgress
    @StateObject private var vm: PracticeViewModel
    @Environment(\.dismiss) private var dismiss

    init(character: ImpressionCharacter) {
        _vm = StateObject(wrappedValue: PracticeViewModel(character: character))
    }

    var body: some View {
        NavigationStack {
            Group {
                switch vm.phase {
                case .tips:
                    TipsView(character: vm.character) { vm.advance() }
                case .listen:
                    ListenView(character: vm.character, currentPhrase: vm.currentPhrase) { vm.advance() }
                case .record:
                    RecordView(vm: vm)
                case .analyzing:
                    AnalyzingView()
                case .result(let score):
                    ResultView(
                        character: vm.character,
                        result: vm.analysisResult!,
                        score: score,
                        xpEarned: vm.xpEarned,
                        isNewBest: vm.isNewBest,
                        hasNextPhrase: vm.currentPhraseIndex < vm.character.phrases.count - 1,
                        onTryAgain: { vm.tryAgain() },
                        onNextPhrase: { vm.nextPhrase() },
                        onDone: { dismiss() }
                    )
                }
            }
            .navigationTitle(vm.character.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    PhaseIndicator(phase: vm.phase)
                }
            }
        }
    }
}

struct PhaseIndicator: View {
    let phase: PracticePhase

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<4, id: \.self) { i in
                Circle()
                    .fill(i <= currentStep ? Color.accentColor : Color.gray.opacity(0.3))
                    .frame(width: 7, height: 7)
            }
        }
    }

    private var currentStep: Int {
        switch phase {
        case .tips: return 0
        case .listen: return 1
        case .record: return 2
        case .analyzing, .result: return 3
        }
    }
}
