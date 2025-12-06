import SwiftData
import SwiftUI

struct ThoughtDetailsScreen: View {
    var thought: ThoughtModel

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var isForgetting = false

    private var formattedDate: String {
        thought.createdDate.formatted(date: .complete, time: .omitted)
    }
    private var formattedTime: String {
        thought.createdDate.formatted(
            Date.FormatStyle()
                .hour(.twoDigits(amPM: .omitted))
                .minute(.twoDigits)
        )
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 24) {
                Text(thought.content)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("ThoughtDetailsScreen/ThoughtDate-Text\(formattedDate)\(formattedTime)")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.quaternary)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button {
                    isForgetting = true
                } label: {
                    Label {
                        Text("ThoughtDetailsScreen/Toolbar/DestructiveAction/Button-Title")
                    } icon: {
                        Image(systemName: "trash")
                    }
                }
                .confirmationDialog(
                    "ThoughtDetailsScreen/Toolbar/DestructiveAction/ConfirmationDialog-Title",
                    isPresented: $isForgetting,
                    titleVisibility: .visible) {
                        Button("ThoughtDetailsScreen/Toolbar/DestructiveAction/ConfirmationDialog/DestructiveButton-Title", role: .destructive) {
                            context.delete(thought)
                            let thinkingDays = FetchDescriptor<ThinkingDayModel>()
                            if let thinkingDay = try? context.fetch(thinkingDays).filter({
                                Calendar.current.isDate($0.date, inSameDayAs: thought.createdDate)
                            }).first, thinkingDay.thoughts.count <= 1 {
                                context.delete(thinkingDay)
                            }
                            try? context.save()
                            dismiss()
                        }
                    }
            }
        }
    }
}
