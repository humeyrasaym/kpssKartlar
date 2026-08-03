import Foundation

enum SeedData {
    static let recommendedCourses: [Course] = [
        Course(id: Course.historyID, title: "Tarih", style: .history, isFromUser: false),
        Course(id: Course.geographyID, title: "Coğrafya", style: .geography, isFromUser: false),
        Course(id: "turkish", title: "Türkçe", style: .turkish, isFromUser: false),
        Course(id: "mathematics", title: "Matematik", style: .mathematics, isFromUser: false),
        Course(id: "citizenship", title: "Vatandaşlık", style: .citizenship, isFromUser: false),
        Course(id: "current-affairs", title: "Güncel Bilgiler", style: .currentAffairs, isFromUser: false),
        Course(id: "education-sciences", title: "Eğitim Bilimleri", style: .education, isFromUser: false)
    ]

    // Gönderilen görsellerde net seçilebilen maddeler aynen korunur.
    static let cards: [Flashcard] = [
        Flashcard(id: "history-kurgan", courseID: Course.historyID, topic: "Eski Türklerde kültür", prompt: "Kurgan ne demektir?", note: "kurgan = mezar"),
        Flashcard(id: "history-sagu", courseID: Course.historyID, topic: "Eski Türklerde kültür", prompt: "Sagu ne demektir?", note: "sagu = ağıt"),
        Flashcard(id: "history-balbal", courseID: Course.historyID, topic: "Eski Türklerde kültür", prompt: "Balbal ne demektir?", note: "balbal = mezar taşı"),
        Flashcard(id: "history-sav", courseID: Course.historyID, topic: "Eski Türklerde kültür", prompt: "Sav ne demektir?", note: "sav = atasözü"),
        Flashcard(id: "history-kun", courseID: Course.historyID, topic: "Eski Türklerde kültür", prompt: "Kün ne demektir?", note: "kün = halk"),
        Flashcard(id: "history-toy", courseID: Course.historyID, topic: "Eski Türklerde kültür", prompt: "Toy ne demektir?", note: "toy = şölen"),
        Flashcard(id: "history-yug", courseID: Course.historyID, topic: "Eski Türklerde kültür", prompt: "Yuğ ne demektir?", note: "yuğ = cenaze töreni"),
        Flashcard(id: "history-tudun", courseID: Course.historyID, topic: "Eski Türklerde devlet", prompt: "Tudun ne demektir?", note: "tudun = vergi memuru"),
        Flashcard(id: "history-pecheneg", courseID: Course.historyID, topic: "İlk Türk devletleri", prompt: "Museviliği benimseyen ilk ve tek Türk devleti hangisidir?", note: "museviliği benimseyen ilk ve tek türk devleti Hazarlar"),
        Flashcard(id: "history-manas", courseID: Course.historyID, topic: "İlk Türk devletleri", prompt: "Manas Destanı'nı hangi topluluk oluşturmuştur?", note: "dünyanın en uzun destanı Manas Destanı'nı oluşturan Kırgızlar"),
        Flashcard(id: "history-karluk", courseID: Course.historyID, topic: "İlk Türk devletleri", prompt: "İslamiyeti kabul eden ilk Türk topluluğu hangisidir?", note: "islamiyeti kabul eden ilk türk topluluğu Karluklar"),
        Flashcard(id: "history-tabgac", courseID: Course.historyID, topic: "İlk Türk devletleri", prompt: "Kuzey Çin'e 200 yıl egemen olan topluluk hangisidir?", note: "kuzey çine 200 yıl egemen olan Tabgaçlar"),
        Flashcard(id: "history-karahanli", courseID: Course.historyID, topic: "Türk-İslam devletleri", prompt: "Orta Asya'da kurulan ilk Türk-İslam devleti hangisidir?", note: "Orta Asya'da kurulan ilk Türk-İslam devleti Karahanlılar"),
        Flashcard(id: "history-pasinler", courseID: Course.historyID, topic: "Büyük Selçuklu", prompt: "Pasinler Savaşı", note: "Pasinler Savaşı: Selçuklular ile Bizans arasındaki ilk önemli mücadeleler. 1048"),
        Flashcard(id: "history-asure", courseID: Course.historyID, topic: "Eski Türklerde devlet", prompt: "Hükümdar soyları", note: "Kağan olabilmek için kök tengri tarafından kut verilmiş bir soydan gelmek gerekirdi. Hükümdarlar bu soy için Göktürklerde Aşina, Uygurlarda ise Yağlakar")
    ]
}
