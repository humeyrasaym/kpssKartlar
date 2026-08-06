import SwiftUI

struct CourseLibraryView: View {
    @EnvironmentObject private var studyController: StudyController
    @State private var isAddingCard = false
    @State private var isAddingCourse = false

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Kartlar")
                            .font(.system(size: 34, weight: .bold, design: .serif))
                        Text("Her madde ayrı bir karttır. İstediğin dersi ekleyip PDF'deki cümleleri aynen saklayabilirsin.")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.warmGray)

                        ForEach(studyController.courses) { course in
                            NavigationLink {
                                CourseDeckView(course: course)
                            } label: {
                                CourseLibraryRow(progress: studyController.progress(for: course))
                            }
                            .buttonStyle(.plain)
                        }

                        Button { isAddingCourse = true } label: {
                            Label("Yeni ders ekle", systemImage: "plus.circle.fill")
                                .font(.subheadline.weight(.bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .foregroundStyle(AppTheme.ink)
                                .background(.white.opacity(0.66), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(AppTheme.line, lineWidth: 1))
                        }
                    }
                    .padding(20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Kart ekle", systemImage: "rectangle.stack.badge.plus") { isAddingCard = true }
                        Button("Ders ekle", systemImage: "book.closed.badge.plus") { isAddingCourse = true }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .tint(AppTheme.ink)
                }
            }
            .sheet(isPresented: $isAddingCard) {
                AddCardSheet(initialCourseID: studyController.courses.first?.id)
                    .presentationDetents([.large])
            }
            .sheet(isPresented: $isAddingCourse) {
                AddCourseSheet()
                    .presentationDetents([.medium])
            }
        }
    }
}

private struct CourseLibraryRow: View {
    let progress: CourseProgress

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                CourseIcon(course: progress.course, size: 20)
                    .frame(width: 40, height: 40)
                    .background(progress.course.style.paleColor, in: Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text(progress.course.title)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(AppTheme.ink)
                    Text("\(progress.total) madde")
                        .font(.caption)
                        .foregroundStyle(AppTheme.warmGray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(AppTheme.warmGray)
            }
            ProgressView(value: progress.fraction)
                .tint(progress.course.style.color)
        }
        .padding(18)
        .background(.white.opacity(0.76), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(AppTheme.line.opacity(0.65), lineWidth: 1))
    }
}
