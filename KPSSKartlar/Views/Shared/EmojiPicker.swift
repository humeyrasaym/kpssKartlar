import SwiftUI

struct EmojiPicker: View {
    @Binding var selection: String

    private static let quickEmojis = [
        "📚", "📖", "🧠", "✍️", "📝", "🗺️", "🌍", "🏛️",
        "⚖️", "➗", "🔢", "🔬", "🧪", "💻", "🌐", "🗣️",
        "🎓", "🎯", "📌", "🧩", "💡", "📊", "🎨", "🎵"
    ]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 6)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Ders emojisi")
                Spacer()
                Text(selection.isEmpty ? "Seçilmedi" : selection)
                    .font(selection.isEmpty ? .subheadline : .title3)
                    .foregroundStyle(selection.isEmpty ? .secondary : .primary)
                    .frame(minWidth: 38, minHeight: 30)
                    .padding(.horizontal, 8)
                    .background(.thinMaterial, in: Capsule())
            }

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(Self.quickEmojis, id: \.self) { emoji in
                    Button {
                        selection = emoji
                    } label: {
                        Text(emoji)
                            .font(.title3)
                            .frame(maxWidth: .infinity, minHeight: 38)
                            .background(selection == emoji ? AppTheme.line.opacity(0.6) : .clear, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(emoji) emojisini seç")
                }
            }

            HStack(spacing: 10) {
                TextField("Emoji klavyesinden istediğini yaz", text: $selection)
                    .font(.body)
                    .onChange(of: selection) { _, value in
                        selection = value.first.map(String.init) ?? ""
                    }

                if !selection.isEmpty {
                    Button("Temizle") { selection = "" }
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(AppTheme.warmGray)
                }
            }

            Text("Emoji klavyesiyle tüm emojileri kullanabilirsin; üstteki seçimler yalnızca hızlı erişim içindir.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
