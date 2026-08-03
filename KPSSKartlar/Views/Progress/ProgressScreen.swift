import SwiftUI

struct ProgressScreen: View {
    @EnvironmentObject private var studyController: StudyController

    private var allKnown: Int { studyController.allCards.filter(studyController.isKnown).count }

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        Text("İlerlemen")
                            .font(.system(size: 34, weight: .bold, design: .serif))
                        Text("Hedef kusursuzluk değil; düzenli karşılaşma.")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.warmGray)

                        HStack(spacing: 18) {
                            ZStack {
                                Circle().stroke(AppTheme.line, lineWidth: 11)
                                Circle()
                                    .trim(from: 0, to: studyController.allCards.isEmpty ? 0 : Double(allKnown) / Double(studyController.allCards.count))
                                    .stroke(AppTheme.ink, style: StrokeStyle(lineWidth: 11, lineCap: .round))
                                    .rotationEffect(.degrees(-90))
                                Text("\(allKnown)").font(.title2.weight(.bold))
                            }
                            .frame(width: 94, height: 94)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("öğrenilen kart").font(.headline)
                                Text("\(studyController.allCards.count) kartın içinden")
                                    .font(.subheadline)
                                    .foregroundStyle(AppTheme.warmGray)
                            }
                        }
                        .padding(20)
                        .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 24, style: .continuous))

                        ForEach(studyController.courses) { course in
                            CourseProgressRow(progress: studyController.progress(for: course))
                        }
                    }
                    .padding(20)
                }
            }
        }
    }
}
