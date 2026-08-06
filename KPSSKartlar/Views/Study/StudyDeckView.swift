import SwiftUI

struct StudyDeckView: View {
    @EnvironmentObject private var studyController: StudyController
    @Environment(\.dismiss) private var dismiss
    let courseID: String?
    @State private var sessionLimit: Int
    @State private var sessionCards: [Flashcard] = []
    @State private var cardIndex = 0
    @State private var isAnswerVisible = false
    @State private var isEditing = false
    @State private var isSessionComplete = false
    @State private var isChoosingNextSession = false
    @State private var nextSessionLimit: Int?

    init(courseID: String?, sessionLimit: Int) {
        self.courseID = courseID
        _sessionLimit = State(initialValue: sessionLimit)
    }

    private var currentCard: Flashcard? {
        guard sessionCards.indices.contains(cardIndex) else { return nil }
        return sessionCards[cardIndex]
    }

    private var remainingReviewCount: Int {
        studyController.cardsForReview(for: courseID).count
    }

    private var hasCardsInDeck: Bool {
        !studyController.cards(for: courseID).isEmpty
    }

    var body: some View {
        GeometryReader { geometry in
            let isCompact = geometry.size.height < 720
            let topInset: CGFloat = isCompact ? 12 : 16
            let bottomInset = max(16, min(geometry.safeAreaInsets.bottom, 40))
            let chromeHeight: CGFloat = isCompact ? 174 : 204
            let cardHeight = min(520, max(300, geometry.size.height - topInset - bottomInset - chromeHeight))

            ZStack {
                PaperBackground()
                if isSessionComplete {
                    completedContent(geometry: geometry, topInset: topInset, bottomInset: bottomInset)
                } else if let card = currentCard, let course = studyController.course(for: card.courseID) {
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
        .sheet(isPresented: $isChoosingNextSession, onDismiss: startSelectedNextSession) {
            StudySessionSetupSheet(selectedLimit: $nextSessionLimit, courseID: courseID)
                .presentationDetents([.medium, .large])
        }
        .onAppear(perform: startSession)
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
                Text("\(cardIndex + 1) / \(sessionCards.count)")
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
                ForEach(sessionCards.indices, id: \.self) { index in
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
            ContentUnavailableView(
                hasCardsInDeck ? "Bu tur için kart kalmadı" : "Henüz kart yok",
                systemImage: hasCardsInDeck ? "checkmark.circle" : "rectangle.stack.badge.plus",
                description: Text(hasCardsInDeck ? "Bildiğin kartlar Öğrendim sekmesinde birikir." : "Bu derse ilk notunu ekleyebilirsin.")
            )
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, topInset)
        .padding(.bottom, bottomInset)
        .frame(width: geometry.size.width, height: geometry.size.height)
    }

    @ViewBuilder
    private func completedContent(geometry: GeometryProxy, topInset: CGFloat, bottomInset: CGFloat) -> some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: dismiss.callAsFunction) {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundStyle(AppTheme.ink)
                        .frame(width: 40, height: 40)
                        .background(.white.opacity(0.7), in: Circle())
                }
                Spacer()
            }

            Spacer()

            VStack(spacing: 15) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 62, weight: .semibold))
                    .foregroundStyle(AppTheme.ink)
                    .padding(18)
                    .background(.white.opacity(0.75), in: Circle())

                Text("Tur tamamlandı")
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundStyle(AppTheme.ink)

                Text("\(sessionCards.count) kartı gözden geçirdin.")
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)

                Text(remainingReviewCount > 0
                     ? "\(remainingReviewCount) kart tekrar akışında kaldı."
                     : "Tüm kartların Öğrendim sekmesinde.")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.warmGray)
                    .multilineTextAlignment(.center)
            }
            .padding(28)
            .frame(maxWidth: .infinity)
            .background(.white.opacity(0.74), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(AppTheme.line.opacity(0.8), lineWidth: 1)
            }

            Spacer()

            if remainingReviewCount > 0 {
                Button(action: showNextSessionSetup) {
                    Label("Yeni tur seç", systemImage: "slider.horizontal.3")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .foregroundStyle(.white)
                        .background(AppTheme.ink, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
                .buttonStyle(.plain)
            }

            Button("Turu kapat", action: dismiss.callAsFunction)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(AppTheme.warmGray)
                .padding(.top, 16)
        }
        .padding(.horizontal, 20)
        .padding(.top, topInset)
        .padding(.bottom, bottomInset)
        .frame(width: geometry.size.width, height: geometry.size.height)
    }

    private func startSession() {
        sessionCards = studyController.reviewSession(for: courseID, limit: sessionLimit)
        cardIndex = 0
        isAnswerVisible = false
        isSessionComplete = false
    }

    private func showNextSessionSetup() {
        nextSessionLimit = nil
        isChoosingNextSession = true
    }

    private func startSelectedNextSession() {
        guard let nextSessionLimit else { return }
        sessionLimit = nextSessionLimit
        self.nextSessionLimit = nil
        startSession()
    }

    private func advance() {
        guard !sessionCards.isEmpty else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            if cardIndex + 1 < sessionCards.count {
                cardIndex += 1
            } else {
                isSessionComplete = true
            }
            isAnswerVisible = false
        }
    }
}
