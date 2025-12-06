import Combine
import SwiftData
import SwiftUI

struct ThoughtListScreen: View {
    @Environment(\.modelContext) private var context

    @Query(sort: \ThinkingDayModel.date, order: .reverse) private var thinkingDays: [ThinkingDayModel]

    @State private var isThinking = false
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(.vertical) {
                if thinkingDays.isEmpty {
                    ContentUnavailableView {
                        VStack(spacing: 10) {
                            Text("🤔")
                                .font(.system(size: 64))
                            Text("ThoughtListScreen/EmptyState-Title")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    } description: {
                        Text("ThoughtListScreen/EmptyState-Description")
                    } actions: {
                        Button {
                            isThinking = true
                        } label: {
                            Label {
                                Text("ThoughtListScreen/EmptyState/Button-Title")
                            } icon: {
                                Image(systemName: "plus")
                            }
                            .padding(8)
                        }
                        .buttonStyle(.glassProminent)
                    }
                } else {
                    VStack {
                        ForEach(thinkingDays) { thinkingDay in
                            DayOfThoughts(navigationPath: $navigationPath, thinkingDay: thinkingDay)
                        }
                    }
                    .padding()
                }
            }
            .defaultScrollAnchor(thinkingDays.isEmpty ? .center : .top)
            .background(BackgroundStyle().secondary)
            .navigationTitle("ThoughtListScreen/NavigationTitle")
            .toolbar {
                if !thinkingDays.isEmpty {
                    ToolbarSpacer(placement: .bottomBar)
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            isThinking = true
                        } label: {
                            Label {
                                Text("ThoughtListScreen/Toolbar/PrimaryAction/Button-Title")
                            } icon: {
                                Image(systemName: "plus")
                            }
                        }
                        .buttonStyle(.glassProminent)
                    }
                }
            }
            .sheet(isPresented: $isThinking) {
                NewThoughtScreen()
                    .interactiveDismissDisabled()
            }
        }
    }
}
