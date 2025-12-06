import SwiftData
import SwiftUI

struct NewThoughtScreen: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context

    @State var newThought = ThoughtModel()

    @State var isCancelling = false

    private var emptyThought: Bool {
        newThought.content.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                TextEditor(text: $newThought.content)
                    .navigationTitle("CreateThoughtScreen/NavigationTitle")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button {
                                if emptyThought {
                                    dismiss()
                                } else {
                                    isCancelling = true
                                }
                            } label: {
                                Label {
                                    Text("NewThoughtScreen/Toolbar/CancellationAction/Button-Title")
                                } icon: {
                                    Image(systemName: "xmark")
                                }
                            }
                            .confirmationDialog(
                                "NewThoughtScreen/Toolbar/CancellationAction/ConfirmationDialog-Title",
                                isPresented: $isCancelling,
                                titleVisibility: .visible
                            ) {
                                Button(
                                    "NewThoughtScreen/Toolbar/CancellationAction/ConfirmationDialog/DestructiveButton-Title",
                                    role: .destructive
                                ) {
                                    dismiss()
                                }
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                saveThought()
                                dismiss()
                            } label: {
                                Label {
                                    Text("NewThoughtScreen/Toolbar/ConfirmationAction/Button-Title")
                                } icon: {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .disabled(emptyThought)
                        }
                    }
                Text("NewThoughtScreen/TextEditorPlaceholder")
                    .foregroundStyle(.quaternary)
                    .padding(.top, 8)
                    .padding(.leading, 5)
                    .opacity(emptyThought ? 1 : 0)
            }
            .padding(.horizontal)
        }
    }

    func saveThought() {
        newThought.content = newThought.content.trimmingCharacters(in: .whitespacesAndNewlines)
        context.insert(newThought)
        let thinkingDays = FetchDescriptor<ThinkingDayModel>()
        if let thinkingDay = try? context.fetch(thinkingDays).filter({
            Calendar.current.isDate($0.date, inSameDayAs: newThought.createdDate)
        }).first {
            thinkingDay.thoughts.append(newThought)
            print(thinkingDay.date)
            print(newThought.createdDate)
        } else {
            let thinkingDay = ThinkingDayModel(date: newThought.createdDate, thoughts: [newThought])
            context.insert(thinkingDay)
            print(thinkingDay.date)
            print(newThought.createdDate)
        }
        try? context.save()
    }
}
