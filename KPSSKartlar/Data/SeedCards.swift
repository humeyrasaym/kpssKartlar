import Foundation

enum SeedCards {
    // Bu başlangıç kartları, gönderilen görsellerde net seçilebilen maddelerden
    // aynen alınmıştır. Yeni PDF notları sonraki eklemelerde değiştirilmeden eklenir.
    static let all: [Flashcard] = [
        Flashcard(id: "history-kurgan", subject: .history, topic: "Eski Türklerde kültür", prompt: "Kurgan ne demektir?", note: "kurgan = mezar"),
        Flashcard(id: "history-sagu", subject: .history, topic: "Eski Türklerde kültür", prompt: "Sagu ne demektir?", note: "sagu = ağıt"),
        Flashcard(id: "history-balbal", subject: .history, topic: "Eski Türklerde kültür", prompt: "Balbal ne demektir?", note: "balbal = mezar taşı"),
        Flashcard(id: "history-sav", subject: .history, topic: "Eski Türklerde kültür", prompt: "Sav ne demektir?", note: "sav = atasözü"),
        Flashcard(id: "history-kun", subject: .history, topic: "Eski Türklerde kültür", prompt: "Kün ne demektir?", note: "kün = halk"),
        Flashcard(id: "history-toy", subject: .history, topic: "Eski Türklerde kültür", prompt: "Toy ne demektir?", note: "toy = şölen"),
        Flashcard(id: "history-yug", subject: .history, topic: "Eski Türklerde kültür", prompt: "Yuğ ne demektir?", note: "yuğ = cenaze töreni"),
        Flashcard(id: "history-tudun", subject: .history, topic: "Eski Türklerde devlet", prompt: "Tudun ne demektir?", note: "tudun = vergi memuru"),
        Flashcard(id: "history-pecheneg", subject: .history, topic: "İlk Türk devletleri", prompt: "Museviliği benimseyen ilk ve tek Türk devleti hangisidir?", note: "museviliği benimseyen ilk ve tek türk devleti Hazarlar"),
        Flashcard(id: "history-manas", subject: .history, topic: "İlk Türk devletleri", prompt: "Manas Destanı'nı hangi topluluk oluşturmuştur?", note: "dünyanın en uzun destanı Manas Destanı'nı oluşturan Kırgızlar"),
        Flashcard(id: "history-karluk", subject: .history, topic: "İlk Türk devletleri", prompt: "İslamiyeti kabul eden ilk Türk topluluğu hangisidir?", note: "islamiyeti kabul eden ilk türk topluluğu Karluklar"),
        Flashcard(id: "history-tabgac", subject: .history, topic: "İlk Türk devletleri", prompt: "Kuzey Çin'e 200 yıl egemen olan topluluk hangisidir?", note: "kuzey çine 200 yıl egemen olan Tabgaçlar"),
        Flashcard(id: "history-karahanli", subject: .history, topic: "Türk-İslam devletleri", prompt: "Orta Asya'da kurulan ilk Türk-İslam devleti hangisidir?", note: "Orta Asya'da kurulan ilk Türk-İslam devleti Karahanlılar"),
        Flashcard(id: "history-pasinler", subject: .history, topic: "Büyük Selçuklu", prompt: "Pasinler Savaşı", note: "Pasinler Savaşı: Selçuklular ile Bizans arasındaki ilk önemli mücadeleler. 1048"),
        Flashcard(id: "history-asure", subject: .history, topic: "Eski Türklerde devlet", prompt: "Hükümdar soyları", note: "Kağan olabilmek için kök tengri tarafından kut verilmiş bir soydan gelmek gerekirdi. Hükümdarlar bu soy için Göktürklerde Aşina, Uygurlarda ise Yağlakar")
    ]
}
