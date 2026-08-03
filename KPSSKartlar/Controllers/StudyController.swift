import Combine
import Foundation

final class StudyController: ObservableObject {
    @Published private(set) var knownCardIDs: Set<String> = [] {
        didSet { saveKnownCards() }
    }
    @Published private(set) var courses: [Course] = [] {
        didSet { saveCourses() }
    }
    @Published private(set) var customCards: [Flashcard] = [] {
        didSet { saveCustomCards() }
    }
    @Published private var cardEdits: [String: Flashcard] = [:] {
        didSet { saveCardEdits() }
    }

    private let knownKey = "kpss.knownCardIDs"
    private let coursesKey = "kpss.courses"
    private let customCardsKey = "kpss.customCards"
    private let editsKey = "kpss.cardEdits"

    init() {
        knownCardIDs = Set(UserDefaults.standard.stringArray(forKey: knownKey) ?? [])

        if let data = UserDefaults.standard.data(forKey: customCardsKey),
           let savedCards = try? JSONDecoder().decode([Flashcard].self, from: data) {
            customCards = savedCards
        }

        if let data = UserDefaults.standard.data(forKey: editsKey),
           let savedEdits = try? JSONDecoder().decode([String: Flashcard].self, from: data) {
            cardEdits = savedEdits
        }

        if let data = UserDefaults.standard.data(forKey: coursesKey),
           let savedCourses = try? JSONDecoder().decode([Course].self, from: data) {
            courses = selectedCourses(from: savedCourses)
        } else {
            courses = []
        }

        addMissingCoursesForSavedCards()
    }

    var allCards: [Flashcard] {
        SeedData.cards.map { cardEdits[$0.id] ?? $0 } + customCards
    }

    func course(for id: String) -> Course? {
        courses.first { $0.id == id }
    }

    func cards(for courseID: String? = nil) -> [Flashcard] {
        let filtered = courseID.map { selected in allCards.filter { $0.courseID == selected } } ?? allCards
        return filtered.sorted { lhs, rhs in
            if lhs.courseID == rhs.courseID { return lhs.topic < rhs.topic }
            return (course(for: lhs.courseID)?.title ?? lhs.courseID) < (course(for: rhs.courseID)?.title ?? rhs.courseID)
        }
    }

    func progress(for course: Course) -> CourseProgress {
        let courseCards = cards(for: course.id)
        let known = courseCards.filter { knownCardIDs.contains($0.id) }.count
        return CourseProgress(course: course, total: courseCards.count, known: known)
    }

    var recommendedCourses: [Course] {
        SeedData.recommendedCourses.filter { suggestion in
            !courses.contains { $0.id == suggestion.id }
        }
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

    @discardableResult
    func addCourse(title: String, style: CourseStyle) -> Bool {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty,
              !courses.contains(where: { $0.title.compare(trimmedTitle, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame }) else {
            return false
        }

        courses.append(Course(title: trimmedTitle, style: style, isFromUser: true))
        return true
    }

    @discardableResult
    func addSuggestedCourse(_ suggestion: Course) -> Bool {
        guard !courses.contains(where: { $0.id == suggestion.id }) else { return false }

        courses.append(
            Course(
                id: suggestion.id,
                title: suggestion.title,
                style: suggestion.style,
                isFromUser: true
            )
        )
        return true
    }

    func addCard(courseID: String, topic: String, prompt: String, note: String, isTwoSided: Bool) {
        let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        guard course(for: courseID) != nil,
              !trimmedNote.isEmpty,
              !isTwoSided || !trimmedPrompt.isEmpty else { return }

        customCards.append(
            Flashcard(
                courseID: courseID,
                topic: normalizedTopic(topic),
                prompt: trimmedPrompt,
                note: trimmedNote,
                isTwoSided: isTwoSided,
                isFromUser: true
            )
        )
    }

    func updateCard(_ card: Flashcard) {
        guard course(for: card.courseID) != nil else { return }

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

    func normalizedTopic(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Kendi notum" : trimmed
    }

    private func selectedCourses(from savedCourses: [Course]) -> [Course] {
        let courseIDsWithCards = Set(allCards.map(\.courseID))
        return savedCourses.filter { course in
            course.isFromUser || courseIDsWithCards.contains(course.id)
        }
    }

    private func addMissingCoursesForSavedCards() {
        let missingIDs = Set(allCards.map(\.courseID)).subtracting(courses.map(\.id))
        for id in missingIDs {
            if let suggestion = SeedData.recommendedCourses.first(where: { $0.id == id }) {
                courses.append(suggestion)
            } else {
                courses.append(Course(id: id, title: "Ders", style: .custom, isFromUser: true))
            }
        }
    }

    private func saveKnownCards() {
        UserDefaults.standard.set(Array(knownCardIDs), forKey: knownKey)
    }

    private func saveCourses() {
        guard let data = try? JSONEncoder().encode(courses) else { return }
        UserDefaults.standard.set(data, forKey: coursesKey)
    }

    private func saveCustomCards() {
        guard let data = try? JSONEncoder().encode(customCards) else { return }
        UserDefaults.standard.set(data, forKey: customCardsKey)
    }

    private func saveCardEdits() {
        guard let data = try? JSONEncoder().encode(cardEdits) else { return }
        UserDefaults.standard.set(data, forKey: editsKey)
    }
}
