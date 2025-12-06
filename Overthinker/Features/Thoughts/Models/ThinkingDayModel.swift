import Foundation
import SwiftData

@Model
class ThinkingDayModel {
    @Attribute(.unique) var date: Date
    var thoughts: [ThoughtModel]
    var summary: String?

    init(date: Date, thoughts: [ThoughtModel], summary: String? = nil) {
        self.date = date
        self.thoughts = thoughts
        self.summary = summary
    }
}
