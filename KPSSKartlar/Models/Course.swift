import Foundation

enum CourseStyle: String, CaseIterable, Codable, Identifiable, Hashable {
    case history
    case geography
    case turkish
    case mathematics
    case citizenship
    case currentAffairs
    case education
    case custom

    var id: String { rawValue }
}

struct Course: Identifiable, Hashable, Codable {
    static let historyID = "history"
    static let geographyID = "geography"

    let id: String
    var title: String
    var style: CourseStyle
    var emoji: String?
    let isFromUser: Bool

    init(
        id: String = UUID().uuidString,
        title: String,
        style: CourseStyle,
        emoji: String? = nil,
        isFromUser: Bool
    ) {
        self.id = id
        self.title = title
        self.style = style
        self.emoji = emoji
        self.isFromUser = isFromUser
    }
}

struct CourseProgress: Hashable {
    let course: Course
    let total: Int
    let known: Int

    var fraction: Double {
        guard total > 0 else { return 0 }
        return Double(known) / Double(total)
    }
}
