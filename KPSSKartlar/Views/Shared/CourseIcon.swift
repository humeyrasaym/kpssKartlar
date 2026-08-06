import SwiftUI

struct CourseIcon: View {
    let course: Course
    var size: CGFloat = 18

    var body: some View {
        Group {
            if let emoji = course.emoji, !emoji.isEmpty {
                Text(emoji)
                    .font(.system(size: size))
            } else {
                Image(systemName: course.style.iconName)
                    .font(.system(size: size, weight: .semibold))
                    .foregroundStyle(course.style.color)
            }
        }
        .frame(width: size + 6, height: size + 6)
        .accessibilityHidden(true)
    }
}
