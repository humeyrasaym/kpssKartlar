# KPSS Kartlar

SwiftUI ile hazırlanmış, iOS 17 ve sonrası için mobil tekrar kartı uygulaması.

## Xcode’da açma

`KPSSKartlar.xcodeproj` dosyasını Xcode ile açın. Bir iPhone simülatörü veya gerçek cihaz seçip çalıştırın.

## Uygulamadaki akış

- **Bugün:** tüm derslerden hızlı tekrar turu.
- **Kartlar:** ders bazlı liste, yeni ders ve yeni kart ekleme.
- **İlerleme:** öğrenilen kart sayısı ve ders bazlı oranlar.
- Kartlar varsayılan olarak tek yüzlüdür ve notun tam metnini aynen gösterir. Kullanıcı dilerse kartı düzenleyerek soru-cevap biçimine dönüştürür.
- **Biliyorum** ve **Tekrarla** seçimleri ile ilerleme cihazda saklanır.

Başlangıçta yalnızca test kartı içeren dersler görünür. Coğrafya, Türkçe, Matematik, Vatandaşlık, Güncel Bilgiler ve Eğitim Bilimleri gibi seçenekler **Yeni ders ekle** ekranında öneri olarak sunulur; kullanıcı seçtiğinde ana ekrana eklenir. Alan bilgisi, yabancı dil veya başka bir çalışma alanı için özel ders de oluşturulabilir.

## Mimari ve dosya düzeni

Uygulama MVC düzenindedir:

- `Models/`: `Course` ve `Flashcard` veri modelleri.
- `Controllers/`: kalıcı veriler, ders/kart işlemleri ve ilerlemeyi yöneten `StudyController`.
- `Views/`: her ekranın kendi Swift dosyası; `Home`, `Courses`, `Cards`, `Study`, `Progress` ve ortak bileşen klasörleri.
- `Data/SeedData.swift`: başlangıç dersleri ve test notları.

Önceki sürümde kaydedilmiş tarih/coğrafya kartları ve ilerleme verileri, yeni ders modeliyle uyumlu şekilde korunur.
