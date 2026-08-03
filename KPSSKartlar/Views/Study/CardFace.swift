import SwiftUI

struct CardFace: View {
    let eyebrow: String
    let title: String
    let helper: String
    let color: Color
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text(eyebrow.uppercased())
                    .font(.caption.weight(.bold))
                    .tracking(0.9)
                Spacer()
                Image(systemName: symbol).font(.headline)
            }
            .foregroundStyle(color)

            ScrollView(showsIndicators: true) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold, design: .serif))
                    .foregroundStyle(AppTheme.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
            }
            .frame(maxHeight: .infinity)

            HStack(spacing: 7) {
                Image(systemName: "hand.tap.fill")
                Text(helper)
            }
            .font(.caption.weight(.medium))
            .foregroundStyle(AppTheme.warmGray)
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(.white.opacity(0.88), in: RoundedRectangle(cornerRadius: 32, style: .continuous))
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 3)
                .fill(color)
                .frame(width: 6)
                .padding(.vertical, 30)
        }
        .overlay(RoundedRectangle(cornerRadius: 32, style: .continuous).stroke(AppTheme.line.opacity(0.8), lineWidth: 1))
        .shadow(color: AppTheme.ink.opacity(0.11), radius: 20, y: 11)
    }
}
