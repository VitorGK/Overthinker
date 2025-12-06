import SwiftData
import SwiftUI

@main
struct OverthinkerApp: App {
    let modelContainer = {
        do {
            let schema = Schema([
                ThoughtModel.self,
                ThinkingDayModel.self
            ])
            let modelContainer = try ModelContainer(for: schema)
            ThoughtService.shared.modelContext = modelContainer.mainContext
            return modelContainer
        } catch {
            print(error.localizedDescription)
            fatalError("Could not initialize ModelContainer")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ThoughtListScreen()
                .modelContainer(modelContainer)
        }
    }
}
