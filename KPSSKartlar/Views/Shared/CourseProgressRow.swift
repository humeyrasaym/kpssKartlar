import SwiftUI

struct CourseProgressRow: View {
    let progress: CourseProgress

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: progress.course.style.iconName)
                .font(.headline)
                .foregroundStyle(progress.course.style.color)
                .frame(width: 44, height: 44)
                .background(progress.course.style.paleColor, in: Circle())
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(progress.course.title)
                        .font(.headline)
                        .foregroundStyle(AppTheme.ink)
                    Spacer()
                    Text("\(progress.known)/\(progress.total)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(AppTheme.warmGray)
                }
                ProgressView(value: progress.fraction)
                    .tint(progress.course.style.color)
            }
        }
        .padding(16)
        .background(.white.opacity(0.74), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(AppTheme.line.opacity(0.65), lineWidth: 1))
    }
}
