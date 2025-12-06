import FoundationModels
import SwiftData
import SwiftUI

struct DayOfThoughts: View {
    @Binding var navigationPath: NavigationPath
    var thinkingDay: ThinkingDayModel

    @Environment(\.modelContext) private var context
    @Namespace private var animation

    @State private var isReadingSummary: ThinkingDayModel?

    @State private var summaryReady = false

    private var formattedDate: String {
        thinkingDay.date.formatted(date: .abbreviated, time: .omitted)
    }

    var body: some View {
        VStack {
            Section {
                ForEach(thinkingDay.thoughts.reversed()) { thought in
                    Button {
                        navigationPath.append(thought)
                    } label: {
                        ThoughtCard(thought: thought)
                    }
                    .buttonStyle(.plain)
                    .navigationDestination(for: ThoughtModel.self) { thought in
                        ThoughtDetailsScreen(thought: thought)
                    }
                }
            } header: {
                HStack(alignment: .bottom) {
                    Text(formattedDate)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)
                        .padding(.leading)
                    Spacer()
                    Button {
                        isReadingSummary = thinkingDay
                    } label: {
                        Label {
                            Text("DayOfThoughts/SectionHeader/SummarizeButton-Title")
                        } icon: {
                            Image(systemName: "sparkles.2")
                        }
                    }
                    .font(.footnote)
                    .buttonStyle(.bordered)
                    .foregroundStyle(.primary)
                    .id(thinkingDay.date)
                    .matchedTransitionSource(id: thinkingDay.date, in: animation)
                }
            }
        }
        .padding(.bottom)
        .fullScreenCover(item: $isReadingSummary) {
            ThoughtSummaryScreen(thinkingDay: $0)
                .navigationTransition(.zoom(sourceID: thinkingDay.date, in: animation))
        }
    }
}
