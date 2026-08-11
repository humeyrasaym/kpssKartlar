import Foundation

enum AquariumTourData {
    /// Osmanlı notlarından türetilen bu turlar, bilgiyi tek tek ezberletmek yerine
    /// KPSS'de sık görülen kurum-padişah, savaş-sonuç ve antlaşma-dönem bağlarını
    /// ayırt ettirir. Soru kökleri özgündür; ÖSYM sorularının kopyası değildir.
    static let tours: [AquariumTour] = [
        reformsBySultan,
        treatiesBySultan,
        treatyConsequences,
        warsBySultan,
        institutionsByPeriod,
        constitutionalMilestones,
        worldWarFronts,
        nationalStruggleMilestones
    ]

    private static let reformsBySultan = AquariumTour(
        id: "ottoman-reforms-by-sultan",
        courseID: Course.historyID,
        title: "Islahatlar · Padişahlar",
        subtitle: "Yeniliği doğru padişah halkasına yerleştir.",
        instruction: "Karttaki gelişmenin hangi padişah dönemine ait olduğunu seç.",
        iconName: "crown.fill",
        groups: [
            AquariumGroup(id: "gench-osman", title: "Genç Osman", detail: "II. Osman"),
            AquariumGroup(id: "mahmut-one", title: "I. Mahmut", detail: "Batı tarzı askerî yenilikler"),
            AquariumGroup(id: "abdulhamit-one", title: "I. Abdülhamit", detail: "Denizcilik ve teknik eğitim"),
            AquariumGroup(id: "selim-three", title: "III. Selim", detail: "Nizam-ı Cedid"),
        ],
        challenges: [
            AquariumChallenge(id: "reform-harem", prompt: "Harem dışından evlilik yapma", correctGroupID: "gench-osman", explanation: "Osmanlı tarihinde ilk ıslahat yapan padişah kabul edilen Genç Osman'ın sosyal alandaki girişimidir."),
            AquariumChallenge(id: "reform-janissary", prompt: "Yeniçeri Ocağını kaldırmayı düşünme", correctGroupID: "gench-osman", explanation: "Genç Osman, ocağı kaldırıp başkenti Anadolu'ya taşımayı planlamıştır."),
            AquariumChallenge(id: "reform-bonneval", prompt: "Comte de Bonneval'i getirip Humbaracı Ocağını ıslah etme", correctGroupID: "mahmut-one", explanation: "Batı'dan getirilen ilk uzman Comte de Bonneval, I. Mahmut döneminde Humbaracı Ocağını ıslah etmiştir."),
            AquariumChallenge(id: "reform-hendesehane", prompt: "Batı tarzındaki ilk teknik okul olan Hendesehaneyi açma", correctGroupID: "mahmut-one", explanation: "Hendesehane, I. Mahmut dönemindeki önemli teknik eğitim yeniliğidir."),
            AquariumChallenge(id: "reform-bahr", prompt: "Mühendishane-i Bahr-i Hümayunu açma", correctGroupID: "abdulhamit-one", explanation: "1775'te açılan Mühendishane-i Bahr-i Hümayun, I. Abdülhamit dönemindedir."),
            AquariumChallenge(id: "reform-zorla-alim", prompt: "Zorla alım-satımı yasaklama", correctGroupID: "abdulhamit-one", explanation: "Bu düzenleme I. Abdülhamit döneminde yapılmıştır."),
            AquariumChallenge(id: "reform-nizam", prompt: "Islahatların bütününe Nizam-ı Cedid adını verme", correctGroupID: "selim-three", explanation: "Nizam-ı Cedid, III. Selim'in askerî ve idarî yeniliklerini kapsar."),
            AquariumChallenge(id: "reform-irad", prompt: "Yeni ordunun masrafları için İrad-ı Cedid Hazinesini kurma", correctGroupID: "selim-three", explanation: "İrad-ı Cedid Hazinesi, Nizam-ı Cedid ordusunun finansmanı için III. Selim döneminde kurulmuştur."),
            AquariumChallenge(id: "reform-embassy", prompt: "Daimî elçilikler açma", correctGroupID: "selim-three", explanation: "İlk daimî elçi Yusuf Agâh Efendi, III. Selim döneminde Londra'ya atanmıştır."),
        ]
    )

    private static let treatiesBySultan = AquariumTour(
        id: "ottoman-treaties-by-sultan",
        courseID: Course.historyID,
        title: "Antlaşmalar · Padişahlar",
        subtitle: "Antlaşmayı doğru saltanat halkasına bırak.",
        instruction: "Antlaşmanın imzalandığı padişah dönemini seç.",
        iconName: "scroll.fill",
        groups: [
            AquariumGroup(id: "ahmet-three", title: "III. Ahmet", detail: "1711–1730"),
            AquariumGroup(id: "mahmut-one", title: "I. Mahmut", detail: "1730–1754"),
            AquariumGroup(id: "abdulhamit-one", title: "I. Abdülhamit", detail: "1774–1789"),
            AquariumGroup(id: "selim-three", title: "III. Selim", detail: "1789–1807"),
        ],
        challenges: [
            AquariumChallenge(id: "treaty-prut", prompt: "1711 Prut Antlaşması", correctGroupID: "ahmet-three", explanation: "Prut Antlaşması III. Ahmet döneminde imzalanmıştır; Azak Kalesi Osmanlı'ya geri verilmiştir."),
            AquariumChallenge(id: "treaty-pasarofca", prompt: "1718 Pasarofça Antlaşması", correctGroupID: "ahmet-three", explanation: "Pasarofça, III. Ahmet döneminde imzalanmış ve Lale Devri'ni başlatmıştır."),
            AquariumChallenge(id: "treaty-belgrad", prompt: "1739 Belgrad Antlaşması", correctGroupID: "mahmut-one", explanation: "Belgrad Antlaşması I. Mahmut döneminde imzalanmış, Belgrad yeniden Osmanlı'ya bırakılmıştır."),
            AquariumChallenge(id: "treaty-kucuk-kaynarca", prompt: "1774 Küçük Kaynarca Antlaşması", correctGroupID: "abdulhamit-one", explanation: "Küçük Kaynarca, I. Abdülhamit döneminde Rusya ile imzalanmıştır."),
            AquariumChallenge(id: "treaty-zistovi", prompt: "1791 Ziştovi Antlaşması", correctGroupID: "selim-three", explanation: "Ziştovi Antlaşması, III. Selim döneminde Osmanlı ile Avusturya arasında imzalanmıştır."),
            AquariumChallenge(id: "treaty-yas", prompt: "1792 Yaş Antlaşması", correctGroupID: "selim-three", explanation: "Yaş Antlaşması ile Kırım'ın Rusya'ya ait olduğu kabul edilmiştir; antlaşma III. Selim dönemindedir."),
        ]
    )

    private static let treatyConsequences = AquariumTour(
        id: "ottoman-treaty-consequences",
        courseID: Course.historyID,
        title: "Antlaşmalar · Sonuçlar",
        subtitle: "Sonucu doğru antlaşma halkasına yerleştir.",
        instruction: "Verilen sonucu hangi antlaşmayla ilişkilendireceğini seç.",
        iconName: "arrow.triangle.branch",
        groups: [
            AquariumGroup(id: "prut", title: "Prut", detail: "1711"),
            AquariumGroup(id: "pasarofca", title: "Pasarofça", detail: "1718"),
            AquariumGroup(id: "kucuk-kaynarca", title: "Küçük Kaynarca", detail: "1774"),
            AquariumGroup(id: "karlofca", title: "Karlofça", detail: "1699"),
        ],
        challenges: [
            AquariumChallenge(id: "result-azakh", prompt: "Azak Kalesi'nin Osmanlı'ya geri verilmesi", correctGroupID: "prut", explanation: "Prut Antlaşması, Karlofça ile kaybedilen toprakları geri alma umudu doğurmuştur."),
            AquariumChallenge(id: "result-lale", prompt: "Lale Devri'nin başlaması ve Batı'nın üstünlüğünün kabulü", correctGroupID: "pasarofca", explanation: "Pasarofça Antlaşması'nın ardından Lale Devri başlamıştır."),
            AquariumChallenge(id: "result-kirim", prompt: "Kırım'ın bağımsız olması", correctGroupID: "kucuk-kaynarca", explanation: "Küçük Kaynarca ile Kırım bağımsız hâle gelmiş, Osmanlı ilk kez bir Türk ve Müslüman toprağını kaybetmiştir."),
            AquariumChallenge(id: "result-tazminat", prompt: "Osmanlı'nın ilk kez savaş tazminatı ödemesi", correctGroupID: "kucuk-kaynarca", explanation: "İlk savaş tazminatı Küçük Kaynarca Antlaşması ile Rusya'ya ödenmiştir."),
            AquariumChallenge(id: "result-west-loss", prompt: "Batı'da ilk kez geniş anlamda toprak kaybedilmesi", correctGroupID: "karlofca", explanation: "Karlofça Antlaşması, Osmanlı'nın Batı'da geniş çaplı ilk toprak kaybıdır."),
            AquariumChallenge(id: "result-period", prompt: "Duraklama Dönemi'nin sona erip Gerileme Dönemi'nin başlaması", correctGroupID: "karlofca", explanation: "Dönem değişimi, Karlofça Antlaşması'nın Osmanlı tarihi açısından önemli sonucudur."),
        ]
    )

    private static let warsBySultan = AquariumTour(
        id: "ottoman-wars-by-sultan",
        courseID: Course.historyID,
        title: "Savaşlar · Padişahlar",
        subtitle: "Savaşı doğru padişah halkasına yerleştir.",
        instruction: "Savaşın yaşandığı padişah dönemini seç; sonuç bağlantısını açıklamada kontrol et.",
        iconName: "shield.fill",
        groups: [
            AquariumGroup(id: "murat-one", title: "I. Murat", detail: "Kuruluş"),
            AquariumGroup(id: "bayezit-one", title: "Yıldırım Bayezit", detail: "Kuruluş"),
            AquariumGroup(id: "fatih", title: "Fatih Sultan Mehmet", detail: "Yükselme"),
            AquariumGroup(id: "yavuz", title: "Yavuz Sultan Selim", detail: "Yükselme"),
            AquariumGroup(id: "kanuni", title: "Kanuni Sultan Süleyman", detail: "Yükselme"),
        ],
        challenges: [
            AquariumChallenge(id: "war-sirpsindigi", prompt: "1364 Sırpsındığı Savaşı", correctGroupID: "murat-one", explanation: "I. Murat dönemindeki ilk Osmanlı-Haçlı savaşıdır; ardından Edirne başkent yapılmıştır."),
            AquariumChallenge(id: "war-nigbolu", prompt: "1396 Niğbolu Savaşı", correctGroupID: "bayezit-one", explanation: "Niğbolu, Yıldırım Bayezit döneminde İstanbul kuşatmasını etkileyen Haçlı savaşıdır."),
            AquariumChallenge(id: "war-ankara", prompt: "1402 Ankara Savaşı", correctGroupID: "bayezit-one", explanation: "Ankara Savaşı, Yıldırım Bayezit'in Timur'a yenilmesiyle Fetret Devri'ni başlatmıştır."),
            AquariumChallenge(id: "war-otlukbeli", prompt: "1473 Otlukbeli Savaşı", correctGroupID: "fatih", explanation: "Fatih Sultan Mehmet, Akkoyunluları Otlukbeli'nde mağlup etmiştir."),
            AquariumChallenge(id: "war-caldiran", prompt: "1514 Çaldıran Savaşı", correctGroupID: "yavuz", explanation: "Yavuz Sultan Selim, Çaldıran'da Safevilerle karşılaşmış; tüfekli askerler etkili olmuştur."),
            AquariumChallenge(id: "war-ridaniye", prompt: "1517 Rıdaniye Savaşı", correctGroupID: "yavuz", explanation: "Rıdaniye ile Memlük Devleti yıkılmış; halifelik ve Baharat Yolu Osmanlı'ya geçmiştir."),
            AquariumChallenge(id: "war-mohac", prompt: "1526 Mohaç Meydan Muharebesi", correctGroupID: "kanuni", explanation: "Dünyanın en kısa süreli ova savaşı sayılan Mohaç, Kanuni dönemindedir."),
            AquariumChallenge(id: "war-preveze", prompt: "1538 Preveze Deniz Savaşı", correctGroupID: "kanuni", explanation: "Preveze zaferi ile Akdeniz Türk gölü hâline gelmiştir."),
        ]
    )

    private static let institutionsByPeriod = AquariumTour(
        id: "ottoman-institutions-by-period",
        courseID: Course.historyID,
        title: "Kurumlar · Dönemler",
        subtitle: "Yeniliği doğru dönem halkasına yerleştir.",
        instruction: "Kurum veya uygulamanın hangi dönemle en güçlü bağlantısı olduğunu seç.",
        iconName: "building.columns.fill",
        groups: [
            AquariumGroup(id: "lale", title: "Lale Devri", detail: "III. Ahmet"),
            AquariumGroup(id: "mahmut-one", title: "I. Mahmut", detail: "1730–1754"),
            AquariumGroup(id: "mustafa-three", title: "III. Mustafa", detail: "1757–1774"),
            AquariumGroup(id: "abdulhamit-one", title: "I. Abdülhamit", detail: "1774–1789"),
            AquariumGroup(id: "selim-three", title: "III. Selim", detail: "1789–1807"),
        ],
        challenges: [
            AquariumChallenge(id: "institution-printing", prompt: "İbrahim Müteferrika ve Sait Efendi'nin getirdiği matbaa", correctGroupID: "lale", explanation: "Osmanlı'ya getirilen ilk teknik yenilik olan matbaa Lale Devri'ndedir."),
            AquariumChallenge(id: "institution-tulumba", prompt: "Tulumbacılar Ocağı", correctGroupID: "lale", explanation: "Tulumbacılar Ocağı, Lale Devri'nde Gerçek Davut Ağa tarafından kurulmuştur."),
            AquariumChallenge(id: "institution-humbaraci", prompt: "Humbaracı Ocağının ıslahı", correctGroupID: "mahmut-one", explanation: "Comte de Bonneval, I. Mahmut döneminde Humbaracı Ocağını ıslah etmiştir."),
            AquariumChallenge(id: "institution-hendese", prompt: "Hendesehane", correctGroupID: "mahmut-one", explanation: "Batı tarzındaki ilk teknik okul olan Hendesehane, I. Mahmut dönemindedir."),
            AquariumChallenge(id: "institution-tersane", prompt: "Tersane Hendesehanesi", correctGroupID: "mustafa-three", explanation: "Deniz Harp Okulunun temeli sayılan Tersane Hendesehanesi, III. Mustafa döneminde açılmıştır."),
            AquariumChallenge(id: "institution-esham", prompt: "Esham senetleri", correctGroupID: "mustafa-three", explanation: "Esham senetleri, III. Mustafa döneminde kâğıt paraya geçişin ilk aşaması sayılır."),
            AquariumChallenge(id: "institution-bahr", prompt: "Mühendishane-i Bahr-i Hümayun", correctGroupID: "abdulhamit-one", explanation: "1775 tarihli Mühendishane-i Bahr-i Hümayun I. Abdülhamit dönemindedir."),
            AquariumChallenge(id: "institution-nizam", prompt: "Nizam-ı Cedid ordusu", correctGroupID: "selim-three", explanation: "Nizam-ı Cedid, III. Selim'in yenilikçi askerî düzenidir."),
            AquariumChallenge(id: "institution-embassy", prompt: "Daimî elçilikler", correctGroupID: "selim-three", explanation: "Daimî elçilikler III. Selim döneminde açılmıştır."),
        ]
    )

    private static let constitutionalMilestones = AquariumTour(
        id: "ottoman-constitutional-milestones",
        courseID: Course.historyID,
        title: "Haklar · Anayasal Süreç",
        subtitle: "Gelişmeyi doğru anayasal halkaya yerleştir.",
        instruction: "Verilen sonucun hangi belge veya döneme ait olduğunu seç.",
        iconName: "building.columns.circle.fill",
        groups: [
            AquariumGroup(id: "sened", title: "Sened-i İttifak", detail: "1808"),
            AquariumGroup(id: "tanzimat", title: "Tanzimat", detail: "1839"),
            AquariumGroup(id: "islahat", title: "Islahat", detail: "1856"),
            AquariumGroup(id: "first-constitution", title: "I. Meşrutiyet", detail: "1876"),
            AquariumGroup(id: "second-constitution", title: "II. Meşrutiyet", detail: "1908–1909")
        ],
        challenges: [
            AquariumChallenge(id: "constitution-ayan", prompt: "Ayanların varlığının resmiyet kazanması", correctGroupID: "sened", explanation: "Sened-i İttifak, ayanların varlığını resmileştirmiş ve padişahın mutlak yetkisini ilk kez sınırlandırmıştır."),
            AquariumChallenge(id: "constitution-mutlak", prompt: "Padişahın mutlak otoritesinin ilk kez sınırlanması", correctGroupID: "sened", explanation: "Bu sonuç Sened-i İttifak ile ortaya çıkmış ve belge Osmanlı'nın Magna Carta'sına benzetilmiştir."),
            AquariumChallenge(id: "constitution-can-mal", prompt: "Can, mal ve ırz güvenliğinin güvenceye alınması", correctGroupID: "tanzimat", explanation: "Tanzimat Fermanı, tüm Osmanlı tebaanın temel güvenlik haklarını düzenlemiştir."),
            AquariumChallenge(id: "constitution-herkes", prompt: "“Herkes” vurgusuyla verginin güce göre alınmasının benimsenmesi", correctGroupID: "tanzimat", explanation: "Tanzimat Fermanı tebaanın tümünü kapsar; “herkes” anahtar sözcüğüyle ayırt edilir."),
            AquariumChallenge(id: "constitution-cizye", prompt: "Cizyenin kaldırılıp gayrimüslimlere askerlik veya bedel seçeneği tanınması", correctGroupID: "islahat", explanation: "Islahat Fermanı özellikle gayrimüslimlerin hukukî statüsü ve eşitliği üzerine düzenlemeler yapmıştır."),
            AquariumChallenge(id: "constitution-mulk", prompt: "Yabancıların Osmanlı ülkesinde mülk edinebilmesi", correctGroupID: "islahat", explanation: "Islahat Fermanı yabancılara Osmanlı sınırları içinde mülk edinme hakkı tanımıştır."),
            AquariumChallenge(id: "constitution-ayen-mebusan", prompt: "Ayan ve Mebusan Meclislerinin açılması", correctGroupID: "first-constitution", explanation: "1876 Kanun-ı Esasi ile I. Meşrutiyet ilan edilmiş ve çift meclisli yapı kurulmuştur."),
            AquariumChallenge(id: "constitution-veto", prompt: "Padişahın kanunları sınırsız veto edip meclisi kapatabilmesi", correctGroupID: "first-constitution", explanation: "Bu geniş padişah yetkileri 1876 Kanun-ı Esasi'nin özelliklerindendir."),
            AquariumChallenge(id: "constitution-meclis-sorumlu", prompt: "Hükûmetin meclise karşı sorumlu hâle gelmesi", correctGroupID: "second-constitution", explanation: "1909 anayasa değişikliği II. Meşrutiyet'te meclisin yetkisini güçlendirmiştir."),
            AquariumChallenge(id: "constitution-political-party", prompt: "Herkesin siyasi parti kurabilmesi", correctGroupID: "second-constitution", explanation: "1909 değişiklikleriyle siyasi hayat genişlemiş; sürgün ve angarya cezaları da kaldırılmıştır.")
        ]
    )

    private static let worldWarFronts = AquariumTour(
        id: "world-war-fronts-by-type",
        courseID: Course.historyID,
        title: "I. Dünya Savaşı · Cepheler",
        subtitle: "Cepheyi savaş amacına göre halkasına bırak.",
        instruction: "Verilen cephe bilgisinin ait olduğu cephe türünü seç.",
        iconName: "shield.lefthalf.filled",
        groups: [
            AquariumGroup(id: "offensive", title: "Taarruz", detail: "Toprak geri alma / yayılma"),
            AquariumGroup(id: "defensive", title: "Savunma", detail: "Toprağı koruma"),
            AquariumGroup(id: "support", title: "Yardım", detail: "Müttefike destek")
        ],
        challenges: [
            AquariumChallenge(id: "front-caucasus", prompt: "Kars, Ardahan ve Batum'u geri alma hedefi", correctGroupID: "offensive", explanation: "Kafkasya Cephesi, Elviye-i Selase'yi geri alma hedefiyle açılan taarruz cephesidir."),
            AquariumChallenge(id: "front-canal", prompt: "İngiltere'nin Mısır-sömürge bağlantısını kesme hedefi", correctGroupID: "offensive", explanation: "Kanal Cephesi, Mısır'ı geri alma ve İngiltere'nin sömürge yollarını kesme amacıyla açılmıştır."),
            AquariumChallenge(id: "front-canakkale", prompt: "İtilafların Boğazlardan geçmesini engelleme", correctGroupID: "defensive", explanation: "Çanakkale Cephesi, Osmanlı'nın savunma cephesi; İtilafların hedefi ise Rusya'ya yardım göndermekti."),
            AquariumChallenge(id: "front-iraq", prompt: "Musul ve Abadan petrollerini koruma", correctGroupID: "defensive", explanation: "Irak Cephesi, İngilizlere karşı yürütülen savunma cephesidir; Kut'ül Amare Zaferi burada kazanılmıştır."),
            AquariumChallenge(id: "front-syria", prompt: "Kanal Cephesi'nin devamı olan ve Mustafa Kemal'in son savaştığı cephe", correctGroupID: "defensive", explanation: "Suriye-Filistin Cephesi savunma cephesi olup Mustafa Kemal burada Hatay-Halep hattını savunmuştur."),
            AquariumChallenge(id: "front-hicaz", prompt: "Kutsal bölgeleri ve bölge petrollerini koruma", correctGroupID: "defensive", explanation: "Hicaz-Yemen Cephesi, İngiltere'nin bölgede etkisini artırma girişimlerine karşı savunma amacı taşır."),
            AquariumChallenge(id: "front-galicia", prompt: "Ruslara karşı savaşmak üzere açılan Avrupa cephesi", correctGroupID: "support", explanation: "Galiçya Cephesi, Osmanlı'nın müttefiklerine yardım amacıyla savaştığı cephelerdendir."),
            AquariumChallenge(id: "front-romania", prompt: "Romanya'ya karşı savaşmak üzere gönderilen birlikler", correctGroupID: "support", explanation: "Romanya Cephesi, müttefiklere yardım için açılan cepheler arasında yer alır."),
            AquariumChallenge(id: "front-macedonia", prompt: "Sırp ve Rus güçlerine karşı müttefike destek", correctGroupID: "support", explanation: "Makedonya Cephesi de yardım cephelerinden biridir."),
            AquariumChallenge(id: "front-brest", prompt: "Rusya'nın savaştan çekilmesiyle Kars, Ardahan ve Batum'un geri alınması", correctGroupID: "offensive", explanation: "Kafkasya Cephesi'ndeki mücadele ve Brest-Litovsk Antlaşması Elviye-i Selase'nin geri alınmasını sağlamıştır.")
        ]
    )

    private static let nationalStruggleMilestones = AquariumTour(
        id: "national-struggle-milestones",
        courseID: Course.historyID,
        title: "Millî Mücadele · Belgeler",
        subtitle: "Kararı doğru kongre veya belge halkasına yerleştir.",
        instruction: "Verilen kararın hangi genelge, kongre veya belgeye ait olduğunu seç.",
        iconName: "flag.checkered.circle.fill",
        groups: [
            AquariumGroup(id: "amasya-circular", title: "Amasya Genelgesi", detail: "21–22 Haziran 1919"),
            AquariumGroup(id: "erzurum", title: "Erzurum Kongresi", detail: "23 Temmuz–7 Ağustos"),
            AquariumGroup(id: "sivas", title: "Sivas Kongresi", detail: "4–11 Eylül"),
            AquariumGroup(id: "amasya-protocol", title: "Amasya Görüşmeleri", detail: "20–22 Ekim"),
            AquariumGroup(id: "misak", title: "Misak-ı Millî", detail: "28 Ocak 1920")
        ],
        challenges: [
            AquariumChallenge(id: "national-vatan", prompt: "“Vatanın bütünlüğü, milletin istiklali tehlikededir.”", correctGroupID: "amasya-circular", explanation: "Amasya Genelgesi Millî Mücadele'nin gerekçesini bu ifadeyle duyurmuştur."),
            AquariumChallenge(id: "national-azim", prompt: "“Milletin bağımsızlığını yine milletin azim ve kararı kurtaracaktır.”", correctGroupID: "amasya-circular", explanation: "Amasya Genelgesi bu kararla Millî Mücadele'nin amaç ve yöntemini ortaya koymuştur."),
            AquariumChallenge(id: "national-manda-first", prompt: "Manda ve himayenin ilk kez reddedilmesi", correctGroupID: "erzurum", explanation: "Erzurum Kongresi'nde manda ve himaye ilk kez reddedilmiştir."),
            AquariumChallenge(id: "national-national-will", prompt: "Kuvayı milliye'yi etkin, millî iradeyi hâkim kılma kararı", correctGroupID: "erzurum", explanation: "Erzurum Kongresi bu kararla ulusal egemenliği ve direniş gücünü birlikte vurgulamıştır."),
            AquariumChallenge(id: "national-cemiyet", prompt: "Yararlı cemiyetlerin tek çatı altında birleşmesi", correctGroupID: "sivas", explanation: "Sivas Kongresi'nde cemiyetler Anadolu ve Rumeli Müdafaa-i Hukuk Cemiyeti adıyla birleştirilmiştir."),
            AquariumChallenge(id: "national-manda-final", prompt: "Manda ve himayenin kesin olarak yeniden gündeme gelmemek üzere reddi", correctGroupID: "sivas", explanation: "Sivas Kongresi, Erzurum'daki reddi kesinleştirmiştir."),
            AquariumChallenge(id: "national-recognition", prompt: "Temsil Heyetinin İstanbul Hükûmeti tarafından resmen tanınması", correctGroupID: "amasya-protocol", explanation: "Amasya Görüşmeleri sonucunda Ali Rıza Paşa Hükûmeti Temsil Heyetini resmen tanımıştır."),
            AquariumChallenge(id: "national-election", prompt: "Mebusan Meclisinin açılması ve ülke genelinde seçim yapılması", correctGroupID: "amasya-protocol", explanation: "Bu karar Amasya Görüşmeleri'nde alınmıştır."),
            AquariumChallenge(id: "national-border", prompt: "Mondros'taki işgal edilmemiş yerlerin vatan bütünü sayılması", correctGroupID: "misak", explanation: "Misak-ı Millî, vatan sınırını 30 Ekim 1918'deki işgal edilmemiş alanlar üzerinden tanımlamıştır."),
            AquariumChallenge(id: "national-capitulations", prompt: "Kapitülasyonların kaldırılmasının istenmesi", correctGroupID: "misak", explanation: "Misak-ı Millî siyasi, adli ve mali sınırlamaların kaldırılmasını; yani tam bağımsızlığı savunur.")
        ]
    )
}
