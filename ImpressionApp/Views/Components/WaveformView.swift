import SwiftUI

struct WaveformView: View {
    let level: Float
    var barCount: Int = 24
    var color: Color = .green

    @State private var bars: [Float] = []
    @State private var timer: Timer?

    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            ForEach(0..<barCount, id: \.self) { i in
                Capsule()
                    .fill(color.gradient)
                    .frame(width: 3, height: CGFloat(bars.indices.contains(i) ? bars[i] : 4))
                    .animation(.spring(response: 0.15), value: bars.indices.contains(i) ? bars[i] : 0)
            }
        }
        .frame(height: 60)
        .onChange(of: level) { _, newLevel in
            pushBar(level: newLevel)
        }
        .onAppear { bars = Array(repeating: 4, count: barCount) }
    }

    private func pushBar(level: Float) {
        let height = max(4, Float(50) * level)
        var updated = bars
        updated.removeFirst()
        updated.append(height)
        bars = updated
    }
}
