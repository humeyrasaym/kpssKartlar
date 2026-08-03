import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var studyController: StudyController
    @State private var isShowingAllStudyCards = false

    private var totalKnown: Int {
        studyController.allCards.filter(studyController.isKnown).count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 7) {
                            Text("KISA BİR TEKRAR")
                                .font(.caption.weight(.bold))
                                .tracking(1.2)
                                .foregroundStyle(AppTheme.warmGray)
                            Text("Zihninde yer aç.")
                                .font(.system(size: 34, weight: .bold, design: .serif))
                                .foregroundStyle(AppTheme.ink)
                            Text("Bugün sadece birkaç kart. Küçük tekrarlar kalıcı olur.")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.warmGray)
                        }

                        Button { isShowingAllStudyCards = true } label: {
                            HStack(alignment: .center, spacing: 16) {
                                Image(systemName: "sparkles")
                                    .font(.title2.weight(.semibold))
                                    .frame(width: 48, height: 48)
                                    .background(.white.opacity(0.18), in: Circle())
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Hızlı tekrar").font(.headline)
                                    Text("\(studyController.allCards.count) kart seni bekliyor")
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.82))
                                }
                                Spacer()
                                Image(systemName: "arrow.right").font(.headline)
                            }
                            .foregroundStyle(.white)
                            .padding(20)
                            .background(AppTheme.ink, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
                        }
                        .buttonStyle(.plain)

                        VStack(alignment: .leading, spacing: 13) {
                            HStack {
                                Text("Derslerin").font(.title3.weight(.bold))
                                Spacer()
                                Text("\(totalKnown) öğrenildi")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(AppTheme.warmGray)
                            }
                            ForEach(studyController.courses) { course in
                                NavigationLink {
                                    CourseDeckView(course: course)
                                } label: {
                                    CourseProgressRow(progress: studyController.progress(for: course))
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        NoteRule()
                        Text("Bir kartı biliyorsan işaretle; emin değilsen tekrar akışında bırak. Uygulama, not metnini değiştirmeden saklar.")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.warmGray)
                            .padding(.bottom, 12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $isShowingAllStudyCards) {
                StudyDeckView(courseID: nil)
            }
        }
    }
}
