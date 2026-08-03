import SwiftUI

struct StudyCard: View {
    let card: Flashcard
    let course: Course
    let isAnswerVisible: Bool

    var body: some View {
        Group {
            if card.isTwoSided {
                ZStack {
                    CardFace(eyebrow: card.topic, title: card.prompt, helper: "Cevabı görmek için dokun", color: course.style.color, symbol: "questionmark")
                        .opacity(isAnswerVisible ? 0 : 1)
                    CardFace(eyebrow: "NOT · \(course.title.uppercased())", title: card.note, helper: "Soruyu yeniden görmek için dokun", color: course.style.color, symbol: "text.quote")
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .opacity(isAnswerVisible ? 1 : 0)
                }
                .rotation3DEffect(.degrees(isAnswerVisible ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            } else {
                CardFace(eyebrow: "MADDE · \(card.topic.uppercased())", title: card.note, helper: "Bu kart tek yüzlü · Soru-cevap için Düzenle'ye dokun", color: course.style.color, symbol: "text.alignleft")
            }
        }
        .animation(.spring(response: 0.42, dampingFraction: 0.82), value: isAnswerVisible)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(card.isTwoSided && !isAnswerVisible ? card.prompt : card.note)
        .accessibilityHint(card.isTwoSided ? "Kartı çevirmek için çift dokunun" : "Bu kart tek yüzlü")
    }
}
