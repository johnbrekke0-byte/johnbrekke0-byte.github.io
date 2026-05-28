import SwiftUI

@main
struct ImpressionApp: App {
    @StateObject private var progress = UserProgress()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(progress)
        }
    }
}
