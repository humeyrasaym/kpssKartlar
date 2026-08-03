import SwiftUI

struct CardListRow: View {
    @EnvironmentObject private var studyController: StudyController
    let card: Flashcard
    let course: Course
    @State private var isEditing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Circle().fill(course.style.color).frame(width: 9, height: 9)
                Text(card.topic.uppercased())
                    .font(.caption2.weight(.bold))
                    .tracking(0.7)
                    .foregroundStyle(AppTheme.warmGray)
                Spacer()
                if studyController.isKnown(card) {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(course.style.color)
                }
            }
            Text(card.note)
                .font(.body)
                .foregroundStyle(AppTheme.ink)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Label(card.isTwoSided ? "Soru · cevap" : "Tek yüz", systemImage: card.isTwoSided ? "rectangle.on.rectangle" : "rectangle")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.warmGray)
                Spacer()
                Button { isEditing = true } label: {
                    Label("Düzenle", systemImage: "pencil").font(.caption.weight(.semibold))
                }
                .foregroundStyle(course.style.color)
                if card.isFromUser {
                    Button(role: .destructive) { studyController.remove(card) } label: {
                        Image(systemName: "trash")
                    }
                    .font(.caption)
                }
            }
        }
        .padding(17)
        .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(AppTheme.line.opacity(0.7), lineWidth: 1))
        .sheet(isPresented: $isEditing) {
            EditCardSheet(card: card).presentationDetents([.large])
        }
    }
}
