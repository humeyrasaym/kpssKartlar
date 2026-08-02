import SwiftUI

enum Subject: String, CaseIterable, Codable, Identifiable {
    case history
    case geography

    var id: String { rawValue }

    var title: String {
        switch self {
        case .history: "Tarih"
        case .geography: "Coğrafya"
        }
    }

    var icon: String {
        switch self {
        case .history: "scroll.fill"
        case .geography: "globe.europe.africa.fill"
        }
    }

    var color: Color {
        switch self {
        case .history: Color(red: 0.73, green: 0.31, blue: 0.23)
        case .geography: Color(red: 0.10, green: 0.43, blue: 0.36)
        }
    }

    var paleColor: Color {
        switch self {
        case .history: Color(red: 0.98, green: 0.91, blue: 0.87)
        case .geography: Color(red: 0.87, green: 0.95, blue: 0.91)
        }
    }
}

struct Flashcard: Identifiable, Hashable, Codable {
    let id: String
    let subject: Subject
    let topic: String
    let prompt: String
    let note: String
    let isTwoSided: Bool
    let isFromUser: Bool

    init(
        id: String = UUID().uuidString,
        subject: Subject,
        topic: String,
        prompt: String = "",
        note: String,
        isTwoSided: Bool = false,
        isFromUser: Bool = false
    ) {
        self.id = id
        self.subject = subject
        self.topic = topic
        self.prompt = prompt
        self.note = note
        self.isTwoSided = isTwoSided
        self.isFromUser = isFromUser
    }

    private enum CodingKeys: String, CodingKey {
        case id, subject, topic, prompt, note, isTwoSided, isFromUser
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        subject = try container.decode(Subject.self, forKey: .subject)
        topic = try container.decode(String.self, forKey: .topic)
        prompt = try container.decodeIfPresent(String.self, forKey: .prompt) ?? ""
        note = try container.decode(String.self, forKey: .note)
        isTwoSided = try container.decodeIfPresent(Bool.self, forKey: .isTwoSided) ?? false
        isFromUser = try container.decodeIfPresent(Bool.self, forKey: .isFromUser) ?? false
    }
}

struct SubjectProgress {
    let subject: Subject
    let total: Int
    let known: Int

    var fraction: Double {
        guard total > 0 else { return 0 }
        return Double(known) / Double(total)
    }
}
