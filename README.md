# KPSS Kartlar

SwiftUI ile hazırlanmış, iOS 17 ve sonrası için mobil tekrar kartı uygulaması.

## Xcode’da açma

`KPSSKartlar.xcodeproj` dosyasını Xcode ile açın. Bir iPhone simülatörü veya gerçek cihaz seçip çalıştırın.

## Uygulamadaki akış

- **Bugün:** tüm derslerden hızlı tekrar turu.
- **Kartlar:** ders bazlı liste ve yeni kart ekleme.
- **İlerleme:** öğrenilen kart sayısı ve ders bazlı oranlar.
- Bir kartın ön yüzünde soru, arka yüzünde notun değişmeden saklanan tam metni bulunur.
- **Biliyorum** ve **Tekrarla** seçimleri ile ilerleme cihazda saklanır.

Başlangıçtaki örnekler, gönderilen görsellerde net seçilebilen tarih notlarıdır. Yeni PDF'lerdeki her madde `SeedCards.swift` içine veya uygulama içinden yeni kart olarak eklenebilir.
