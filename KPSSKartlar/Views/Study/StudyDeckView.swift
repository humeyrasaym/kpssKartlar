import SwiftUI

struct StudyDeckView: View {
    @EnvironmentObject private var studyController: StudyController
    @Environment(\.dismiss) private var dismiss
    let courseID: String?
    @State private var cardIndex = 0
    @State private var isAnswerVisible = false
    @State private var isEditing = false

    private var cards: [Flashcard] { studyController.cards(for: courseID) }
    private var currentCard: Flashcard? { cards.isEmpty ? nil : cards[min(cardIndex, cards.count - 1)] }

    var body: some View {
        GeometryReader { geometry in
            let isCompact = geometry.size.height < 720
            let topInset: CGFloat = isCompact ? 12 : 16
            let bottomInset = max(16, min(geometry.safeAreaInsets.bottom, 40))
            let chromeHeight: CGFloat = isCompact ? 174 : 204
            let cardHeight = min(520, max(300, geometry.size.height - topInset - bottomInset - chromeHeight))

            ZStack {
                PaperBackground()
                if let card = currentCard, let course = studyController.course(for: card.courseID) {
                    studyContent(card: card, course: course, geometry: geometry, topInset: topInset, bottomInset: bottomInset, cardHeight: cardHeight, isCompact: isCompact)
                } else {
                    emptyContent(geometry: geometry, topInset: topInset, bottomInset: bottomInset)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .sheet(isPresented: $isEditing) {
            if let currentCard { EditCardSheet(card: currentCard).presentationDetents([.large]) }
        }
    }

    @ViewBuilder
    private func studyContent(card: Flashcard, course: Course, geometry: GeometryProxy, topInset: CGFloat, bottomInset: CGFloat, cardHeight: CGFloat, isCompact: Bool) -> some View {
        VStack(spacing: isCompact ? 13 : 18) {
            HStack {
                Button(action: dismiss.callAsFunction) {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundStyle(AppTheme.ink)
                        .frame(width: 40, height: 40)
                        .background(.white.opacity(0.7), in: Circle())
                }
                Spacer()
                Text("\(cardIndex + 1) / \(cards.count)")
                    .font(.caption.weight(.bold))
                    .monospacedDigit()
                    .foregroundStyle(AppTheme.warmGray)
                Spacer()
                Button { isEditing = true } label: {
                    Image(systemName: "pencil")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(AppTheme.ink)
                        .frame(width: 40, height: 40)
                        .background(.white.opacity(0.7), in: Circle())
                }
            }

            HStack(spacing: 5) {
                ForEach(cards.indices, id: \.self) { index in
                    Capsule()
                        .fill(index <= cardIndex ? course.style.color : AppTheme.line)
                        .frame(height: 4)
                }
            }

            StudyCard(card: card, course: course, isAnswerVisible: isAnswerVisible)
                .frame(height: cardHeight)
                .onTapGesture {
                    guard card.isTwoSided else { return }
                    withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) { isAnswerVisible.toggle() }
                }

            Spacer(minLength: 0)

            HStack(spacing: 12) {
                DeckActionButton(title: "Tekrarla", icon: "arrow.uturn.left", color: AppTheme.ink) {
                    studyController.mark(card, known: false)
                    advance()
                }
                DeckActionButton(title: "Biliyorum", icon: "checkmark", color: course.style.color) {
                    studyController.mark(card, known: true)
                    advance()
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, topInset)
        .padding(.bottom, bottomInset)
        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
    }

    @ViewBuilder
    private func emptyContent(geometry: GeometryProxy, topInset: CGFloat, bottomInset: CGFloat) -> some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: dismiss.callAsFunction) {
                    Label("Geri", systemImage: "chevron.left")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.ink)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 11)
                        .background(.white.opacity(0.78), in: Capsule())
                }
                Spacer()
            }
            Spacer()
            ContentUnavailableView("Henüz kart yok", systemImage: "rectangle.stack.badge.plus", description: Text("Bu derse ilk notunu ekleyebilirsin."))
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, topInset)
        .padding(.bottom, bottomInset)
        .frame(width: geometry.size.width, height: geometry.size.height)
    }

    private func advance() {
        guard !cards.isEmpty else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            cardIndex = (cardIndex + 1) % cards.count
            isAnswerVisible = false
        }
    }
}
