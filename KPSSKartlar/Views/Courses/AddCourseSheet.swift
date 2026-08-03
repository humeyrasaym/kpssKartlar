import SwiftUI

struct AddCourseSheet: View {
    @EnvironmentObject private var studyController: StudyController
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var style: CourseStyle = .custom
    @State private var isShowingDuplicateWarning = false

    var body: some View {
        NavigationStack {
            Form {
                if !studyController.recommendedCourses.isEmpty {
                    Section("Önerilen dersler") {
                        ForEach(studyController.recommendedCourses) { course in
                            Button {
                                if studyController.addSuggestedCourse(course) {
                                    dismiss()
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: course.style.iconName)
                                        .foregroundStyle(course.style.color)
                                        .frame(width: 28)
                                    Text(course.title)
                                        .foregroundStyle(AppTheme.ink)
                                    Spacer()
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(course.style.color)
                                }
                            }
                        }
                    }
                }

                Section("Kendi dersin") {
                    TextField("Ders adı", text: $title)
                    Picker("Simge", selection: $style) {
                        ForEach(CourseStyle.allCases) { option in
                            Label(option.pickerTitle, systemImage: option.iconName).tag(option)
                        }
                    }
                }
                Section {
                    Text("Alan bilgisi, yabancı dil veya kendi çalışma başlıkların dahil istediğin her ders için kart oluşturabilirsin. Önerilen derslerden birine dokunman yeterli.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Yeni ders")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Bu ders zaten var", isPresented: $isShowingDuplicateWarning) {
                Button("Tamam", role: .cancel) { }
            } message: {
                Text("Farklı bir ders adı yazabilirsin.")
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Vazgeç", action: dismiss.callAsFunction) }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        if studyController.addCourse(title: title, style: style) {
                            dismiss()
                        } else {
                            isShowingDuplicateWarning = true
                        }
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
