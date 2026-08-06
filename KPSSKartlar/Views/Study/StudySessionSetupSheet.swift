import SwiftUI

struct StudySessionSetupSheet: View {
    @EnvironmentObject private var studyController: StudyController
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLimit: Int?
    let courseID: String?

    private var availableCardCount: Int {
        studyController.cardsForReview(for: courseID).count
    }

    private var accentColor: Color {
        courseID.flatMap { studyController.course(for: $0)?.style.color } ?? AppTheme.ink
    }

    private var deckName: String {
        courseID.flatMap { studyController.course(for: $0)?.title } ?? "Tüm dersler"
    }

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 22) {
                        VStack(alignment: .leading, spacing: 7) {
                            Text("ODAKLI TEKRAR")
                                .font(.caption.weight(.bold))
                                .tracking(1.2)
                                .foregroundStyle(AppTheme.warmGray)
                            Text("Turunu sen seç.")
                                .font(.system(size: 32, weight: .bold, design: .serif))
                                .foregroundStyle(AppTheme.ink)
                            Text("\(deckName) için \(availableCardCount) kart tekrar akışında.")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.warmGray)
                        }

                        VStack(spacing: 10) {
                            ForEach(StudyController.sessionSizeOptions, id: \.self) { limit in
                                sessionOption(limit)
                            }
                        }

                        Text("Biliyorum dediğin kartlar turdan çıkar ve Öğrendim sekmesinde birikir.")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.warmGray)
                            .padding(.top, 2)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Kaç kart?")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç", action: dismiss.callAsFunction)
                }
            }
        }
    }

    private func sessionOption(_ limit: Int) -> some View {
        let actualCount = min(limit, availableCardCount)

        return Button {
            selectedLimit = limit
            dismiss()
        } label: {
            HStack(spacing: 14) {
                Text("\(limit)")
                    .font(.title2.weight(.bold))
                    .monospacedDigit()
                    .frame(width: 54, height: 54)
                    .foregroundStyle(accentColor)
                    .background(accentColor.opacity(0.12), in: Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text("\(actualCount) kartlık tur")
                        .font(.headline)
                        .foregroundStyle(AppTheme.ink)
                    Text(actualCount == limit ? "Bu turda \(limit) kart çalışırsın." : "Şimdilik \(actualCount) kart hazır.")
                        .font(.caption)
                        .foregroundStyle(AppTheme.warmGray)
                }

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.warmGray)
            }
            .padding(15)
            .background(.white.opacity(0.76), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(AppTheme.line.opacity(0.75), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .disabled(availableCardCount == 0)
    }
}
