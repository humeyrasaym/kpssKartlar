import SwiftUI

struct CourseDeckView: View {
    @EnvironmentObject private var studyController: StudyController
    let course: Course
    @State private var isStudying = false

    var body: some View {
        ZStack {
            PaperBackground()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 13) {
                    Button { isStudying = true } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("\(course.title) turunu başlat").font(.headline)
                                Text("Kartlara dokun, cevabı hatırla.")
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

                    if studyController.cards(for: course.id).isEmpty {
                        ContentUnavailableView("Henüz kart yok", systemImage: "rectangle.stack.badge.plus", description: Text("Bu derse ilk notunu Kartlar sekmesinden ekleyebilirsin."))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 48)
                    } else {
                        ForEach(studyController.cards(for: course.id)) { card in
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
    }
}
