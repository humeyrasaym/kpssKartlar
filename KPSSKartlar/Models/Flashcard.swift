import Foundation

struct Flashcard: Identifiable, Hashable, Codable {
    let id: String
    let courseID: String
    let topic: String
    let prompt: String
    let note: String
    let isTwoSided: Bool
    let isFromUser: Bool

    init(
        id: String = UUID().uuidString,
        courseID: String,
        topic: String,
        prompt: String = "",
        note: String,
        isTwoSided: Bool = false,
        isFromUser: Bool = false
    ) {
        self.id = id
        self.courseID = courseID
        self.topic = topic
        self.prompt = prompt
        self.note = note
        self.isTwoSided = isTwoSided
        self.isFromUser = isFromUser
    }

    private enum CodingKeys: String, CodingKey {
        case id, courseID, subject, topic, prompt, note, isTwoSided, isFromUser
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        courseID = try container.decodeIfPresent(String.self, forKey: .courseID)
            ?? container.decodeIfPresent(String.self, forKey: .subject)
            ?? Course.historyID
        topic = try container.decode(String.self, forKey: .topic)
        prompt = try container.decodeIfPresent(String.self, forKey: .prompt) ?? ""
        note = try container.decode(String.self, forKey: .note)
        isTwoSided = try container.decodeIfPresent(Bool.self, forKey: .isTwoSided) ?? false
        isFromUser = try container.decodeIfPresent(Bool.self, forKey: .isFromUser) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(courseID, forKey: .courseID)
        try container.encode(topic, forKey: .topic)
        try container.encode(prompt, forKey: .prompt)
        try container.encode(note, forKey: .note)
        try container.encode(isTwoSided, forKey: .isTwoSided)
        try container.encode(isFromUser, forKey: .isFromUser)
    }
}
