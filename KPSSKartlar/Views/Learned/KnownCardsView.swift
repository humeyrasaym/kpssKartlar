import SwiftUI

struct KnownCardsView: View {
    @EnvironmentObject private var studyController: StudyController

    private var cardsByCourse: [(course: Course, cards: [Flashcard])] {
        studyController.courses.compactMap { course in
            let cards = studyController.knownCards(for: course.id)
            guard !cards.isEmpty else { return nil }
            return (course, cards)
        }
    }

    private var knownCount: Int {
        cardsByCourse.reduce(0) { $0 + $1.cards.count }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()

                if cardsByCourse.isEmpty {
                    ContentUnavailableView(
                        "Henüz öğrenilen kart yok",
                        systemImage: "checkmark.circle",
                        description: Text("Bir kartta Biliyorum dediğinde burada birikir.")
                    )
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 22) {
                            VStack(alignment: .leading, spacing: 7) {
                                Text("ÖĞRENDİKLERİN")
                                    .font(.caption.weight(.bold))
                                    .tracking(1.2)
                                    .foregroundStyle(AppTheme.warmGray)
                                Text("Ayrı tuttuk.")
                                    .font(.system(size: 34, weight: .bold, design: .serif))
                                    .foregroundStyle(AppTheme.ink)
                                Text("\(knownCount) kartı tekrar akışından ayırdın. İstersen istediğin kartı yeniden çalışmaya alabilirsin.")
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.warmGray)
                            }

                            ForEach(cardsByCourse, id: \.course.id) { section in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Label(section.course.title, systemImage: section.course.style.iconName)
                                            .font(.headline)
                                            .foregroundStyle(section.course.style.color)
                                        Spacer()
                                        Text("\(section.cards.count) kart")
                                            .font(.caption.weight(.semibold))
                                            .foregroundStyle(AppTheme.warmGray)
                                    }

                                    ForEach(section.cards) { card in
                                        VStack(spacing: 8) {
                                            CardListRow(card: card, course: section.course)

                                            Button {
                                                studyController.mark(card, known: false)
                                            } label: {
                                                Label("Tekrar akışına al", systemImage: "arrow.uturn.left")
                                                    .font(.caption.weight(.bold))
                                                    .frame(maxWidth: .infinity)
                                                    .padding(.vertical, 12)
                                                    .foregroundStyle(section.course.style.color)
                                                    .background(section.course.style.paleColor, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
