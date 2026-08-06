import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var studyController: StudyController
    @State private var isShowingStudySetup = false
    @State private var isShowingAllStudyCards = false
    @State private var selectedSessionLimit: Int?

    private var totalKnown: Int {
        studyController.allCards.filter(studyController.isKnown).count
    }

    private var reviewCardCount: Int {
        studyController.cardsForReview().count
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
                            Text("Turunun boyutunu sen seç. Küçük tekrarlar kalıcı olur.")
                                .font(.subheadline)
                                .foregroundStyle(AppTheme.warmGray)
                        }

                        if reviewCardCount > 0 {
                            Button(action: showStudySetup) {
                            HStack(alignment: .center, spacing: 16) {
                                Image(systemName: "sparkles")
                                    .font(.title2.weight(.semibold))
                                    .frame(width: 48, height: 48)
                                    .background(.white.opacity(0.18), in: Circle())
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Hızlı tekrar").font(.headline)
                                    Text("Kaç kart çalışacağını seç")
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
                        } else {
                            HStack(alignment: .center, spacing: 16) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2.weight(.semibold))
                                    .frame(width: 48, height: 48)
                                    .background(.white.opacity(0.18), in: Circle())
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Bugünlük tamam").font(.headline)
                                    Text("Bildiğin kartlar Öğrendim sekmesinde.")
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.82))
                                }
                                Spacer()
                            }
                            .foregroundStyle(.white)
                            .padding(20)
                            .background(AppTheme.ink, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
                        }

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
                        Text("Biliyorum dediğin kartlar Öğrendim sekmesinde birikir. Emin değilsen tekrar akışında bırak; not metni hiç değişmez.")
                            .font(.footnote)
                            .foregroundStyle(AppTheme.warmGray)
                            .padding(.bottom, 12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingStudySetup, onDismiss: startSelectedSession) {
                StudySessionSetupSheet(selectedLimit: $selectedSessionLimit, courseID: nil)
                    .presentationDetents([.medium, .large])
            }
            .fullScreenCover(isPresented: $isShowingAllStudyCards) {
                StudyDeckView(courseID: nil, sessionLimit: selectedSessionLimit ?? StudyController.sessionSizeOptions[0])
            }
        }
    }

    private func showStudySetup() {
        selectedSessionLimit = nil
        isShowingStudySetup = true
    }

    private func startSelectedSession() {
        guard selectedSessionLimit != nil else { return }
        isShowingAllStudyCards = true
    }
}
