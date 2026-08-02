import Foundation
import Combine

final class StudyStore: ObservableObject {
    @Published private(set) var knownCardIDs: Set<String> = [] {
        didSet { saveKnownCards() }
    }
    @Published private(set) var customCards: [Flashcard] = [] {
        didSet { saveCustomCards() }
    }
    @Published private var cardEdits: [String: Flashcard] = [:] {
        didSet { saveCardEdits() }
    }

    private let knownKey = "kpss.knownCardIDs"
    private let customKey = "kpss.customCards"
    private let editsKey = "kpss.cardEdits"

    init() {
        knownCardIDs = Set(UserDefaults.standard.stringArray(forKey: knownKey) ?? [])
        if let data = UserDefaults.standard.data(forKey: customKey),
           let savedCards = try? JSONDecoder().decode([Flashcard].self, from: data) {
            customCards = savedCards
        }
        if let data = UserDefaults.standard.data(forKey: editsKey),
           let savedEdits = try? JSONDecoder().decode([String: Flashcard].self, from: data) {
            cardEdits = savedEdits
        }
    }

    var allCards: [Flashcard] {
        SeedCards.all.map { cardEdits[$0.id] ?? $0 } + customCards
    }

    func cards(for subject: Subject? = nil) -> [Flashcard] {
        let filtered = subject.map { selected in allCards.filter { $0.subject == selected } } ?? allCards
        return filtered.sorted { lhs, rhs in
            if lhs.subject == rhs.subject { return lhs.topic < rhs.topic }
            return lhs.subject.title < rhs.subject.title
        }
    }

    func progress(for subject: Subject) -> SubjectProgress {
        let subjectCards = cards(for: subject)
        let known = subjectCards.filter { knownCardIDs.contains($0.id) }.count
        return SubjectProgress(subject: subject, total: subjectCards.count, known: known)
    }

    func isKnown(_ card: Flashcard) -> Bool {
        knownCardIDs.contains(card.id)
    }

    func mark(_ card: Flashcard, known: Bool) {
        if known {
            knownCardIDs.insert(card.id)
        } else {
            knownCardIDs.remove(card.id)
        }
    }

    func addCard(subject: Subject, topic: String, prompt: String, note: String, isTwoSided: Bool) {
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedNote.isEmpty, !isTwoSided || !trimmedPrompt.isEmpty else { return }

        customCards.append(
            Flashcard(
                subject: subject,
                topic: topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Kendi notum" : topic.trimmingCharacters(in: .whitespacesAndNewlines),
                prompt: trimmedPrompt,
                note: trimmedNote,
                isTwoSided: isTwoSided,
                isFromUser: true
            )
        )
    }

    func updateCard(_ card: Flashcard) {
        if card.isFromUser, let index = customCards.firstIndex(where: { $0.id == card.id }) {
            customCards[index] = card
        } else {
            cardEdits[card.id] = card
        }
    }

    func remove(_ card: Flashcard) {
        guard card.isFromUser else { return }
        customCards.removeAll { $0.id == card.id }
        knownCardIDs.remove(card.id)
    }

    private func saveKnownCards() {
        UserDefaults.standard.set(Array(knownCardIDs), forKey: knownKey)
    }

    private func saveCustomCards() {
        guard let data = try? JSONEncoder().encode(customCards) else { return }
        UserDefaults.standard.set(data, forKey: customKey)
    }

    private func saveCardEdits() {
        guard let data = try? JSONEncoder().encode(cardEdits) else { return }
        UserDefaults.standard.set(data, forKey: editsKey)
    }
}
