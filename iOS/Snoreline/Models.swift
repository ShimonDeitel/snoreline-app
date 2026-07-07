import Foundation

struct SnoreEntry: Identifiable, Codable, Equatable {
    let id: UUID
    var createdAt: Date
    var date: Date
    var trigger: String

    init(id: UUID = UUID(), createdAt: Date = Date(), date: Date = Date(), trigger: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.date = date
        self.trigger = trigger
    }
}
