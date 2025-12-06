import Foundation
import Observation
import SwiftData

@Observable
class ThoughtService {
    static let shared = {
        let instance = ThoughtService()
        return instance
    }()

    private init() {}

    var modelContext: ModelContext?

    func insert(_ newThought: ThoughtModel) {
        if let modelContext {
            modelContext.insert(newThought)
            let thinkingDays = FetchDescriptor<ThinkingDayModel>()
            if let thinkingDay = try? modelContext.fetch(thinkingDays).filter({
                Calendar.current.isDate($0.date, inSameDayAs: newThought.createdDate)
            }).first {
                thinkingDay.thoughts.append(newThought)
            } else {
                let date = Calendar.current.startOfDay(for: newThought.createdDate)
                let thinkingDay = ThinkingDayModel(date: date, thoughts: [newThought])
                modelContext.insert(thinkingDay)
            }
            try? modelContext.save()
        }
    }
}
