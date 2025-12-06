import AppIntents

struct OverthinkerShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: QuickThoughtIntent(),
            phrases: ["Add new Quick Thought to \(.applicationName)"],
            shortTitle: "OverthinkerShortcuts/QuickThoughtIntent-ShortTitle",
            systemImageName: "cloud"
        )
    }
}
