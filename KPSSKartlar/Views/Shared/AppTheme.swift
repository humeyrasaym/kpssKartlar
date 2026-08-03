import SwiftUI

enum AppTheme {
    static let ink = Color(red: 0.11, green: 0.14, blue: 0.16)
    static let paper = Color(red: 0.98, green: 0.96, blue: 0.91)
    static let warmGray = Color(red: 0.42, green: 0.42, blue: 0.38)
    static let line = Color(red: 0.86, green: 0.83, blue: 0.76)
}

extension CourseStyle {
    var iconName: String {
        switch self {
        case .history: "scroll.fill"
        case .geography: "globe.europe.africa.fill"
        case .turkish: "text.book.closed.fill"
        case .mathematics: "function"
        case .citizenship: "building.columns.fill"
        case .currentAffairs: "newspaper.fill"
        case .education: "graduationcap.fill"
        case .custom: "square.grid.2x2.fill"
        }
    }

    var color: Color {
        switch self {
        case .history: Color(red: 0.73, green: 0.31, blue: 0.23)
        case .geography: Color(red: 0.10, green: 0.43, blue: 0.36)
        case .turkish: Color(red: 0.19, green: 0.36, blue: 0.66)
        case .mathematics: Color(red: 0.42, green: 0.29, blue: 0.68)
        case .citizenship: Color(red: 0.38, green: 0.34, blue: 0.24)
        case .currentAffairs: Color(red: 0.70, green: 0.40, blue: 0.12)
        case .education: Color(red: 0.57, green: 0.24, blue: 0.49)
        case .custom: Color(red: 0.23, green: 0.45, blue: 0.52)
        }
    }

    var paleColor: Color {
        color.opacity(0.13)
    }

    var pickerTitle: String {
        switch self {
        case .history: "Tarih"
        case .geography: "Coğrafya"
        case .turkish: "Türkçe"
        case .mathematics: "Matematik"
        case .citizenship: "Vatandaşlık"
        case .currentAffairs: "Güncel bilgiler"
        case .education: "Eğitim bilimleri"
        case .custom: "Genel"
        }
    }
}

struct PaperBackground: View {
    var body: some View {
        AppTheme.paper
            .overlay {
                LinearGradient(
                    colors: [.white.opacity(0.36), .clear, Color(red: 0.91, green: 0.87, blue: 0.78).opacity(0.22)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .ignoresSafeArea()
    }
}

struct NoteRule: View {
    var body: some View {
        HStack(spacing: 8) {
            Rectangle().fill(AppTheme.line).frame(height: 1)
            Circle().fill(AppTheme.line).frame(width: 5, height: 5)
            Rectangle().fill(AppTheme.line).frame(height: 1)
        }
    }
}
