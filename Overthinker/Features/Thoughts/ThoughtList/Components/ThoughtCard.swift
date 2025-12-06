import SwiftUI

struct ThoughtCard: View {
    var thought: ThoughtModel

    var formattedTime: String {
        thought.createdDate.formatted(
            Date.FormatStyle()
                .hour(.twoDigits(amPM: .omitted))
                .minute(.twoDigits)
        )
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(thought.content)
                    .lineLimit(3)
                Text(formattedTime)
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
                    .padding(.bottom, -8)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundStyle(.tertiary)
                .padding(.trailing, -4)
        }
        .padding()
        .background(BackgroundStyle().secondary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
