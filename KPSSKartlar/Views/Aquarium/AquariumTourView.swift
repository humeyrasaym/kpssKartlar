import SwiftUI

struct AquariumTourView: View {
    @Environment(\.dismiss) private var dismiss
    let tour: AquariumTour

    @State private var queue: [AquariumChallenge] = []
    @State private var currentChallenge: AquariumChallenge?
    @State private var selectedGroupID: String?
    @State private var incorrectChallenges: [AquariumChallenge] = []
    @State private var correctCount = 0
    @State private var activeRoundCount = 0
    @State private var isFinished = false
    @State private var isReviewingOuterCircle = false

    private var initialCount: Int { tour.challenges.count }

    private var selectedGroup: AquariumGroup? {
        tour.groups.first { $0.id == selectedGroupID }
    }

    private var correctGroup: AquariumGroup? {
        guard let currentChallenge else { return nil }
        return tour.groups.first { $0.id == currentChallenge.correctGroupID }
    }

    private var isCorrect: Bool {
        selectedGroupID == currentChallenge?.correctGroupID
    }

    private var completedCount: Int {
        max(0, activeRoundCount - queue.count - (currentChallenge == nil ? 0 : 1))
    }

    var body: some View {
        ZStack {
            PaperBackground()

            if isFinished {
                completionContent
            } else if let currentChallenge {
                studyContent(challenge: currentChallenge)
            }
        }
        .navigationTitle(tour.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard currentChallenge == nil, !isFinished else { return }
            begin(tour.challenges, reviewingOuterCircle: false)
        }
    }

    private func studyContent(challenge: AquariumChallenge) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                VStack(alignment: .leading, spacing: 7) {
                    HStack {
                        Label(isReviewingOuterCircle ? "DIŞ HALKA TEKRARI" : "AKVARYUM TURU", systemImage: isReviewingOuterCircle ? "arrow.triangle.2.circlepath" : "circle.hexagongrid.fill")
                            .font(.caption.weight(.bold))
                            .tracking(0.8)
                            .foregroundStyle(CourseStyle.history.color)
                        Spacer()
                        Text("\(min(completedCount + 1, max(1, activeRoundCount))) / \(max(1, activeRoundCount))")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(AppTheme.warmGray)
                    }
                    Text(tour.instruction)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.warmGray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                AquariumCard(challenge: challenge, iconName: tour.iconName)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Hangi halka?")
                        .font(.headline)
                        .foregroundStyle(AppTheme.ink)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(tour.groups) { group in
                            GroupChoiceButton(
                                group: group,
                                isSelected: selectedGroupID == group.id,
                                isCorrectAnswer: selectedGroupID != nil && group.id == challenge.correctGroupID,
                                isWrongSelection: selectedGroupID == group.id && !isCorrect,
                                action: { select(group) }
                            )
                            .disabled(selectedGroupID != nil)
                        }
                    }
                }

                if let selectedGroup, let correctGroup {
                    feedbackCard(selectedGroup: selectedGroup, correctGroup: correctGroup, challenge: challenge)
                }
            }
            .padding(20)
            .padding(.bottom, 24)
        }
    }

    private func feedbackCard(selectedGroup: AquariumGroup, correctGroup: AquariumGroup, challenge: AquariumChallenge) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "arrow.uturn.left.circle.fill")
                Text(isCorrect ? "İç halkaya geçti" : "Dış halkada kalacak")
                    .font(.headline)
            }
            .foregroundStyle(isCorrect ? Color.green : CourseStyle.history.color)

            if !isCorrect {
                Text("Doğru halka: \(correctGroup.title)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(AppTheme.ink)
            }

            Text(challenge.explanation)
                .font(.footnote)
                .foregroundStyle(AppTheme.warmGray)
                .fixedSize(horizontal: false, vertical: true)

            Button(action: advance) {
                Text(queue.isEmpty ? "Turu tamamla" : "Sonraki kart")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .foregroundStyle(.white)
                    .background(CourseStyle.history.color, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke((isCorrect ? Color.green : CourseStyle.history.color).opacity(0.25), lineWidth: 1)
        }
    }

    private var completionContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 22) {
                Spacer(minLength: 40)

                Image(systemName: incorrectChallenges.isEmpty ? "checkmark.seal.fill" : "circle.hexagongrid.fill")
                    .font(.system(size: 54, weight: .semibold))
                    .foregroundStyle(incorrectChallenges.isEmpty ? Color.green : CourseStyle.history.color)
                    .frame(width: 104, height: 104)
                    .background(.white.opacity(0.68), in: Circle())

                VStack(spacing: 8) {
                    Text(incorrectChallenges.isEmpty ? "Akvaryum tamamlandı" : "Dış halka hazır")
                        .font(.system(size: 30, weight: .bold, design: .serif))
                        .foregroundStyle(AppTheme.ink)
                    Text(summaryText)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(AppTheme.warmGray)
                }

                VStack(spacing: 10) {
                    if !incorrectChallenges.isEmpty {
                        Button(action: repeatOuterCircle) {
                            Label("Dış halkayı tekrar et", systemImage: "arrow.counterclockwise")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundStyle(.white)
                                .background(CourseStyle.history.color, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }

                    Button(action: dismiss.callAsFunction) {
                        Text("Turlara dön")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .foregroundStyle(AppTheme.ink)
                            .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
                Spacer(minLength: 28)
            }
            .padding(24)
            .frame(maxWidth: .infinity, minHeight: 620)
        }
    }

    private var summaryText: String {
        if isReviewingOuterCircle {
            return incorrectChallenges.isEmpty
                ? "Dış halkadaki tüm bağlantıları da doğru yerleştirdin."
                : "\(incorrectChallenges.count) kart hâlâ dış halkada. İstersen tekrar deneyebilirsin."
        }
        return incorrectChallenges.isEmpty
            ? "\(initialCount) ilişki kartının tamamını doğru halkaya yerleştirdin."
            : "İlk turda \(correctCount)/\(initialCount) kart iç halkaya geçti. \(incorrectChallenges.count) kartı şimdi kısa bir tekrar turuna alabilirsin."
    }

    private func select(_ group: AquariumGroup) {
        guard selectedGroupID == nil else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedGroupID = group.id
        }
    }

    private func advance() {
        guard let currentChallenge else { return }

        if isCorrect {
            if !isReviewingOuterCircle { correctCount += 1 }
        } else {
            incorrectChallenges.append(currentChallenge)
        }

        selectedGroupID = nil

        if queue.isEmpty {
            self.currentChallenge = nil
            isFinished = true
        } else {
            self.currentChallenge = queue.removeFirst()
        }
    }

    private func repeatOuterCircle() {
        let challengesToRepeat = incorrectChallenges.shuffled()
        guard !challengesToRepeat.isEmpty else { return }
        incorrectChallenges = []
        begin(challengesToRepeat, reviewingOuterCircle: true)
    }

    private func begin(_ challenges: [AquariumChallenge], reviewingOuterCircle: Bool) {
        let shuffledChallenges = challenges.shuffled()
        queue = Array(shuffledChallenges.dropFirst())
        currentChallenge = shuffledChallenges.first
        activeRoundCount = shuffledChallenges.count
        selectedGroupID = nil
        isFinished = false
        isReviewingOuterCircle = reviewingOuterCircle
    }
}

private struct AquariumCard: View {
    let challenge: AquariumChallenge
    let iconName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Label("BAĞLANTI KARTI", systemImage: iconName)
                    .font(.caption.weight(.bold))
                    .tracking(0.9)
                    .foregroundStyle(CourseStyle.history.color)
                Spacer()
                Image(systemName: "drop.fill")
                    .foregroundStyle(CourseStyle.history.color.opacity(0.75))
            }

            Text(challenge.prompt)
                .font(.system(size: 27, weight: .bold, design: .serif))
                .foregroundStyle(AppTheme.ink)
                .fixedSize(horizontal: false, vertical: true)

            Text("Bu bilgiyi doğru ilişki halkasına yerleştir.")
                .font(.footnote)
                .foregroundStyle(AppTheme.warmGray)
        }
        .frame(maxWidth: .infinity, minHeight: 210, alignment: .leading)
        .padding(22)
        .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(alignment: .leading) {
            Capsule()
                .fill(CourseStyle.history.color)
                .frame(width: 6)
                .padding(.vertical, 20)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(AppTheme.line, lineWidth: 1)
        }
    }
}

private struct GroupChoiceButton: View {
    let group: AquariumGroup
    let isSelected: Bool
    let isCorrectAnswer: Bool
    let isWrongSelection: Bool
    let action: () -> Void

    private var borderColor: Color {
        if isCorrectAnswer { return .green }
        if isWrongSelection { return CourseStyle.history.color }
        return CourseStyle.history.color.opacity(isSelected ? 0.9 : 0.26)
    }

    private var fillColor: Color {
        if isCorrectAnswer { return Color.green.opacity(0.13) }
        if isWrongSelection { return CourseStyle.history.paleColor }
        return .white.opacity(0.72)
    }

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Text(group.title)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(AppTheme.ink)
                    .lineLimit(2)
                Text(group.detail)
                    .font(.caption2)
                    .foregroundStyle(AppTheme.warmGray)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
            .padding(12)
            .background(fillColor, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 17, style: .continuous)
                    .stroke(borderColor, lineWidth: isSelected || isCorrectAnswer ? 2 : 1)
            }
        }
        .buttonStyle(.plain)
    }
}
