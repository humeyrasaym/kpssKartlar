import SwiftUI

struct AquariumLibraryView: View {
    private let tours = AquariumTourData.tours

    var body: some View {
        ZStack {
            PaperBackground()
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("TARİH AKVARYUMU")
                            .font(.caption.weight(.bold))
                            .tracking(1.2)
                            .foregroundStyle(AppTheme.warmGray)
                        Text("Bağlantıyı kur, bilgiyi yerleştir.")
                            .font(.system(size: 30, weight: .bold, design: .serif))
                            .foregroundStyle(AppTheme.ink)
                        Text("Osmanlı bilgisini padişah, antlaşma, savaş ve kurum halkalarına yerleştir. Yanlışların tur sonunda dış halkada tekrar gelir.")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.warmGray)
                    }

                    ForEach(tours) { tour in
                        NavigationLink {
                            AquariumTourView(tour: tour)
                        } label: {
                            AquariumTourRow(tour: tour)
                        }
                        .buttonStyle(.plain)
                    }

                    NoteRule()
                    Label("Soru kökleri KPSS'nin kurum–padişah, savaş–sonuç ve antlaşma–dönem ayırt etme mantığına göre özgün olarak hazırlanır.", systemImage: "checkmark.seal")
                        .font(.footnote)
                        .foregroundStyle(AppTheme.warmGray)
                        .padding(.bottom, 8)
                }
                .padding(20)
            }
        }
        .navigationTitle("Akvaryum Turları")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct AquariumTourRow: View {
    let tour: AquariumTour

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: tour.iconName)
                .font(.title3.weight(.semibold))
                .foregroundStyle(CourseStyle.history.color)
                .frame(width: 48, height: 48)
                .background(CourseStyle.history.paleColor, in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(tour.title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)
                Text(tour.subtitle)
                    .font(.caption)
                    .foregroundStyle(AppTheme.warmGray)
                    .fixedSize(horizontal: false, vertical: true)
                Text("\(tour.challenges.count) ilişki kartı")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(CourseStyle.history.color)
            }

            Spacer(minLength: 6)
            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.warmGray)
        }
        .padding(16)
        .background(.white.opacity(0.76), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(CourseStyle.history.color.opacity(0.18), lineWidth: 1)
        }
    }
}
