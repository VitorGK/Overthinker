import AppIntents
import SwiftData

struct QuickThoughtIntent: AppIntent {
    static var title: LocalizedStringResource = "QuickThoughtIntent-Title"
    static var description = IntentDescription("QuickThoughtIntent-Description")
    static var supportedModes: IntentModes = .background

    @Parameter(
        title: "QuickThoughtIntent/Parameter/QuickThought-Title",
        description: "QuickThoughtIntent/Parameter/QuickThought-Description",
        requestValueDialog: IntentDialog("QuickThoughtIntent/Parameter/QuickThought-RequestValueDialog")
    ) var quickThought: String

    @MainActor
    func perform() async throws -> some IntentResult {
        let newThought = ThoughtModel(content: quickThought.trimmingCharacters(in: .whitespacesAndNewlines))
        ThoughtService.shared.insert(newThought)
        return .result()
    }
}
