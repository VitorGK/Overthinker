import FoundationModels
import SwiftData
import SwiftUI

struct ThoughtSummaryScreen: View {
    var thinkingDay: ThinkingDayModel
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var isSummaryReady = false

    private var formattedDate: String {
        thinkingDay.date.formatted(date: .complete, time: .omitted)
    }

    var body: some View {
        NavigationStack {
            Group {
                if let summary = thinkingDay.summary {
                    ScrollView(.vertical) {
                        VStack(spacing: 24) {
                            Text(summary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("ThoughtSummaryScreen/ThoughtDate-Text\(formattedDate)")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.quaternary)
                        }
                        .padding()
                    }
                } else {
                    Image(systemName: "lightbulb")
                        .font(.system(size: 64))
                        .symbolEffect(
                            .bounce,
                            options: .repeat(.continuous),
                            isActive: !isSummaryReady
                        )
                }
            }
            .onAppear {
                summarize()
            }
            .navigationTitle("ThoughtSummaryScreen/NavigationTitle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if thinkingDay.summary != nil {
                    ToolbarItem(placement: .destructiveAction) {
                        Button(role: .destructive) {
                            thinkingDay.summary = nil
                            summarize()
                        } label: {
                            Label {
                                Text("ThoughtSummaryScreen/Toolbar/DestructiveAction/DestructiveButton-Title")
                            } icon: {
                                Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                            }
                        }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Label {
                            Text("ThoughtSummaryScreen/Toolbar/CancellationAction/Button-Title")
                        } icon: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
        }
    }

    func summarize() {
        guard thinkingDay.summary != nil else {
            Task {
                let prompt = Prompt {
                    thinkingDay.thoughts.map { thought in
                        "\(thought.createdDate.formatted(date: .long, time: .shortened)):\n\(thought.content)\n"
                    }
                }
                let instructions = """
Summarize the given thoughts, objectively.
Write in first person like writting in a journal/diary.
Don't generate new content, just use the one present in the entries provided.
Must reply just the summary.
"""
                let session = LanguageModelSession(instructions: instructions)
                do {
                    let response = try await session.respond(to: prompt)
                    thinkingDay.summary = response.content
                    try? context.save()
                    isSummaryReady = true
                } catch {
                    print("\(error.localizedDescription)")
                }
            }
            return
        }
        isSummaryReady = true
    }
}
