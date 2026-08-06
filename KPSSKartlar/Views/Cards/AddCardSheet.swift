import SwiftUI

struct AddCardSheet: View {
    @EnvironmentObject private var studyController: StudyController
    @Environment(\.dismiss) private var dismiss
    private let initialCourseID: String?

    @State private var courseID: String
    @State private var topic = ""
    @State private var prompt = ""
    @State private var note = ""
    @State private var isTwoSided = false
    @State private var isShowingSavedCardOptions = false

    init(initialCourseID: String? = nil) {
        self.initialCourseID = initialCourseID
        _courseID = State(initialValue: initialCourseID ?? "")
    }

    private var canSave: Bool {
        !courseID.isEmpty &&
        !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (!isTwoSided || !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Ders") {
                    Picker("Ders", selection: $courseID) {
                        ForEach(studyController.courses) { course in
                            HStack(spacing: 8) {
                                CourseIcon(course: course, size: 15)
                                Text(course.title)
                            }
                            .tag(course.id)
                        }
                    }
                }
                Section("Kartın tipi") {
                    Toggle("Soru-cevap kartı", isOn: $isTwoSided)
                    Text(isTwoSided ? "Ön yüzde soru, arka yüzde not görünür." : "Not tek yüzde, aynen görünür.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Section("Madde · aynen") {
                    TextField("Konu (isteğe bağlı)", text: $topic)
                    TextEditor(text: $note).frame(minHeight: 150)
                    Text("Bu alana PDF'deki maddeyi kısaltmadan yaz. Kartın arka yüzünde aynen görünür.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                if isTwoSided {
                    Section("Kartın ön yüzü") {
                        TextField("Hatırlatma sorusu", text: $prompt, axis: .vertical).lineLimit(2...4)
                    }
                }
            }
            .onAppear {
                if courseID.isEmpty { courseID = initialCourseID ?? studyController.courses.first?.id ?? "" }
            }
            .navigationTitle("Yeni kart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Vazgeç", action: dismiss.callAsFunction) }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        studyController.addCard(courseID: courseID, topic: topic, prompt: prompt, note: note, isTwoSided: isTwoSided)
                        isShowingSavedCardOptions = true
                    }
                    .disabled(!canSave)
                }
            }
            .alert("Kart eklendi", isPresented: $isShowingSavedCardOptions) {
                Button("Yeni kart ekle") {
                    prepareForNextCard()
                }
                Button("Bitti") {
                    dismiss()
                }
            } message: {
                Text("Aynı ders seçili kalacak. Yeni kartını hemen ekleyebilirsin.")
            }
        }
    }

    private func prepareForNextCard() {
        topic = ""
        prompt = ""
        note = ""
    }
}
