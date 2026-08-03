import SwiftUI

struct EditCardSheet: View {
    @EnvironmentObject private var studyController: StudyController
    @Environment(\.dismiss) private var dismiss
    let card: Flashcard

    @State private var courseID: String
    @State private var topic: String
    @State private var prompt: String
    @State private var note: String
    @State private var isTwoSided: Bool

    init(card: Flashcard) {
        self.card = card
        _courseID = State(initialValue: card.courseID)
        _topic = State(initialValue: card.topic)
        _prompt = State(initialValue: card.prompt)
        _note = State(initialValue: card.note)
        _isTwoSided = State(initialValue: card.isTwoSided)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Ders") {
                    Picker("Ders", selection: $courseID) {
                        ForEach(studyController.courses) { course in
                            Label(course.title, systemImage: course.style.iconName).tag(course.id)
                        }
                    }
                }
                Section("Kartın tipi") {
                    Toggle("Soru-cevap kartı", isOn: $isTwoSided)
                    Text(isTwoSided ? "Kart çevrilince notun tam metni görünür." : "Kartın tek yüzünde notun tam metni görünür.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Section("Not metni · aynen") {
                    TextField("Konu (isteğe bağlı)", text: $topic)
                    TextEditor(text: $note).frame(minHeight: 150)
                }
                if isTwoSided {
                    Section("Ön yüz sorusu") {
                        TextField("Hatırlatma sorusu", text: $prompt, axis: .vertical).lineLimit(2...4)
                    }
                }
            }
            .navigationTitle("Kartı düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Vazgeç", action: dismiss.callAsFunction) }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        studyController.updateCard(
                            Flashcard(
                                id: card.id,
                                courseID: courseID,
                                topic: studyController.normalizedTopic(topic),
                                prompt: prompt.trimmingCharacters(in: .whitespacesAndNewlines),
                                note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                                isTwoSided: isTwoSided,
                                isFromUser: card.isFromUser
                            )
                        )
                        dismiss()
                    }
                    .disabled(courseID.isEmpty || note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || (isTwoSided && prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty))
                }
            }
        }
    }
}
