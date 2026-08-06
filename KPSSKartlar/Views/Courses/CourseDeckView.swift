import SwiftUI

struct CourseDeckView: View {
    @EnvironmentObject private var studyController: StudyController
    let course: Course
    @State private var isStudying = false
    @State private var isAddingCard = false

    private var courseCards: [Flashcard] {
        studyController.cards(for: course.id)
    }

    private var reviewCardCount: Int {
        studyController.cardsForReview(for: course.id).count
    }

    var body: some View {
        ZStack {
            PaperBackground()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 13) {
                    if reviewCardCount > 0 {
                        Button { isStudying = true } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("\(course.title) turunu başlat").font(.headline)
                                    Text("\(min(StudyController.defaultSessionSize, reviewCardCount)) kartlık odak turu hazır.")
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.82))
                                }
                                Spacer()
                                Image(systemName: "play.fill")
                                    .frame(width: 42, height: 42)
                                    .background(.white.opacity(0.18), in: Circle())
                            }
                            .padding(18)
                            .foregroundStyle(.white)
                            .background(course.style.color, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    } else if !courseCards.isEmpty {
                        Label("Bu derste tekrar bekleyen kart yok.", systemImage: "checkmark.circle.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(course.style.color)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(18)
                            .background(course.style.paleColor, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                    }

                    Button { isAddingCard = true } label: {
                        Label("Bu derse kart ekle", systemImage: "rectangle.stack.badge.plus")
                            .font(.subheadline.weight(.bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(course.style.color)
                            .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(course.style.color.opacity(0.28), lineWidth: 1)
                            }
                    }
                    .buttonStyle(.plain)

                    if courseCards.isEmpty {
                        ContentUnavailableView("Henüz kart yok", systemImage: "rectangle.stack.badge.plus", description: Text("Bu derse ilk notunu Kartlar sekmesinden ekleyebilirsin."))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 48)
                    } else {
                        ForEach(courseCards) { card in
                            CardListRow(card: card, course: course)
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle(course.title)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $isStudying) {
            StudyDeckView(courseID: course.id)
        }
        .sheet(isPresented: $isAddingCard) {
            AddCardSheet(initialCourseID: course.id)
                .presentationDetents([.large])
        }
    }
}
