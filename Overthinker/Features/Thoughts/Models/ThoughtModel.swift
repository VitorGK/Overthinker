import Foundation
import SwiftData

@Model
class ThoughtModel {
    @Attribute(.unique) var id = UUID()
    var createdDate = Date.now

    var content: String

    init(content: String = "") {
        self.content = content
    }
}
