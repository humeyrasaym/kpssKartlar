import SwiftUI

private enum Palette {
    static let ink = Color(red: 0.11, green: 0.14, blue: 0.16)
    static let paper = Color(red: 0.98, green: 0.96, blue: 0.91)
    static let warmGray = Color(red: 0.42, green: 0.42, blue: 0.38)
    static let line = Color(red: 0.86, green: 0.83, blue: 0.76)
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Bugün", systemImage: "sun.max.fill") }
            SubjectLibraryView()
                .tabItem { Label("Kartlar", systemImage: "rectangle.stack.fill") }
            ProgressViewScreen()
                .tabItem { Label("İlerleme", systemImage: "chart.bar.fill") }
        }
        .tint(Palette.ink)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Palette.paper.ignoresSafeArea())
    }
}

private struct HomeView: View {
    @EnvironmentObject private var studyStore: StudyStore
    @State private var isShowingAllStudyCards = false

    private var totalKnown: Int {
        studyStore.allCards.filter(studyStore.isKnown).count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 7) {
                            Text("KISA BİR TEKRAR")
                                .font(.caption.weight(.bold))
                                .tracking(1.2)
                                .foregroundStyle(Palette.warmGray)
                            Text("Zihninde yer aç.")
                                .font(.system(size: 34, weight: .bold, design: .serif))
                                .foregroundStyle(Palette.ink)
                            Text("Bugün sadece birkaç kart. Küçük tekrarlar kalıcı olur.")
                                .font(.subheadline)
                                .foregroundStyle(Palette.warmGray)
                        }

                        Button {
                            isShowingAllStudyCards = true
                        } label: {
                            HStack(alignment: .center, spacing: 16) {
                                Image(systemName: "sparkles")
                                    .font(.title2.weight(.semibold))
                                    .frame(width: 48, height: 48)
                                    .background(.white.opacity(0.18), in: Circle())
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("Hızlı tekrar")
                                        .font(.headline)
                                    Text("\(studyStore.allCards.count) kart seni bekliyor")
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.82))
                                }
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                            }
                            .foregroundStyle(.white)
                            .padding(20)
                            .background(Palette.ink, in: RoundedRectangle(cornerRadius: 26, style: .continuous))
                        }
                        .buttonStyle(.plain)

                        VStack(alignment: .leading, spacing: 13) {
                            HStack {
                                Text("Derslerin")
                                    .font(.title3.weight(.bold))
                                Spacer()
                                Text("\(totalKnown) öğrenildi")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(Palette.warmGray)
                            }
                            ForEach(Subject.allCases) { subject in
                                NavigationLink {
                                    DeckListView(subject: subject)
                                } label: {
                                    SubjectRow(progress: studyStore.progress(for: subject))
                                }
                                .buttonStyle(.plain)
                            }
                        }

                        NoteRule()
                        Text("Bir kartı biliyorsan işaretle; emin değilsen tekrar akışında bırak. Uygulama, not metnini değiştirmeden saklar.")
                            .font(.footnote)
                            .foregroundStyle(Palette.warmGray)
                            .padding(.bottom, 12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isShowingAllStudyCards) {
                StudyDeckView(subject: nil)
            }
        }
    }
}

private struct SubjectLibraryView: View {
    @EnvironmentObject private var studyStore: StudyStore
    @State private var isAddingCard = false

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Kartlar")
                            .font(.system(size: 34, weight: .bold, design: .serif))
                        Text("Her madde ayrı bir karttır. PDF'deki cümleleri burada aynen tutabilirsin.")
                            .font(.subheadline)
                            .foregroundStyle(Palette.warmGray)

                        ForEach(Subject.allCases) { subject in
                            NavigationLink {
                                DeckListView(subject: subject)
                            } label: {
                                let progress = studyStore.progress(for: subject)
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: subject.icon)
                                            .font(.headline)
                                            .foregroundStyle(subject.color)
                                            .frame(width: 40, height: 40)
                                            .background(subject.paleColor, in: Circle())
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(subject.title)
                                                .font(.title3.weight(.bold))
                                                .foregroundStyle(Palette.ink)
                                            Text("\(progress.total) madde")
                                                .font(.caption)
                                                .foregroundStyle(Palette.warmGray)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.caption.weight(.bold))
                                            .foregroundStyle(Palette.warmGray)
                                    }
                                    ProgressView(value: progress.fraction)
                                        .tint(subject.color)
                                }
                                .padding(18)
                                .background(.white.opacity(0.76), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).stroke(Palette.line.opacity(0.65), lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isAddingCard = true
                    } label: {
                        Label("Kart ekle", systemImage: "plus")
                    }
                    .tint(Palette.ink)
                }
            }
            .sheet(isPresented: $isAddingCard) {
                AddCardSheet()
                    .presentationDetents([.large])
            }
        }
    }
}

private struct DeckListView: View {
    @EnvironmentObject private var studyStore: StudyStore
    let subject: Subject
    @State private var isStudying = false

    var body: some View {
        ZStack {
            PaperBackground()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 13) {
                    Button {
                        isStudying = true
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("\(subject.title) turunu başlat")
                                    .font(.headline)
                                Text("Kartlara dokun, cevabı hatırla.")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.82))
                            }
                            Spacer()
                            Image(systemName: "play.fill")
                                .frame(width: 42, height: 42)
                                .background(.white.opacity(0.18), in: Circle())
                        }
                        .padding(18)
                        .foregroundStyle(.white)
                        .background(subject.color, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                    }
                    .buttonStyle(.plain)

                    ForEach(studyStore.cards(for: subject)) { card in
                        CardListRow(card: card)
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle(subject.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isStudying) {
            StudyDeckView(subject: subject)
        }
    }
}

private struct CardListRow: View {
    @EnvironmentObject private var studyStore: StudyStore
    let card: Flashcard
    @State private var isEditing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Circle()
                    .fill(card.subject.color)
                    .frame(width: 9, height: 9)
                Text(card.topic.uppercased())
                    .font(.caption2.weight(.bold))
                    .tracking(0.7)
                    .foregroundStyle(Palette.warmGray)
                Spacer()
                if studyStore.isKnown(card) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(card.subject.color)
                }
            }
            Text(card.note)
                .font(.body)
                .foregroundStyle(Palette.ink)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Label(card.isTwoSided ? "Soru · cevap" : "Tek yüz", systemImage: card.isTwoSided ? "rectangle.on.rectangle" : "rectangle")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Palette.warmGray)
                Spacer()
                Button {
                    isEditing = true
                } label: {
                    Label("Düzenle", systemImage: "pencil")
                        .font(.caption.weight(.semibold))
                }
                .foregroundStyle(card.subject.color)
                if card.isFromUser {
                    Button(role: .destructive) { studyStore.remove(card) } label: {
                        Image(systemName: "trash")
                    }
                    .font(.caption)
                }
            }
        }
        .padding(17)
        .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Palette.line.opacity(0.7), lineWidth: 1))
        .sheet(isPresented: $isEditing) {
            EditCardSheet(card: card)
                .presentationDetents([.large])
        }
    }
}

private struct StudyDeckView: View {
    @EnvironmentObject private var studyStore: StudyStore
    @Environment(\.dismiss) private var dismiss
    let subject: Subject?
    @State private var cardIndex = 0
    @State private var isAnswerVisible = false
    @State private var isEditing = false

    private var cards: [Flashcard] { studyStore.cards(for: subject) }
    private var currentCard: Flashcard? { cards.isEmpty ? nil : cards[min(cardIndex, cards.count - 1)] }
    private var accent: Color { currentCard?.subject.color ?? Palette.ink }

    var body: some View {
        GeometryReader { geometry in
            let isCompact = geometry.size.height < 720
            let topInset = max(12, geometry.safeAreaInsets.top + 8)
            let bottomInset = max(12, geometry.safeAreaInsets.bottom + 8)
            let chromeHeight: CGFloat = isCompact ? 174 : 204
            let cardHeight = min(520, max(300, geometry.size.height - topInset - bottomInset - chromeHeight))

            ZStack {
                PaperBackground()
                if let card = currentCard {
                    VStack(spacing: isCompact ? 13 : 18) {
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "xmark")
                                    .font(.headline)
                                    .foregroundStyle(Palette.ink)
                                    .frame(width: 40, height: 40)
                                    .background(.white.opacity(0.7), in: Circle())
                            }
                            Spacer()
                            Text("\(cardIndex + 1) / \(cards.count)")
                                .font(.caption.weight(.bold))
                                .monospacedDigit()
                                .foregroundStyle(Palette.warmGray)
                            Spacer()
                            Button {
                                isEditing = true
                            } label: {
                                Image(systemName: "pencil")
                                    .font(.subheadline.weight(.bold))
                                    .foregroundStyle(Palette.ink)
                                    .frame(width: 40, height: 40)
                                    .background(.white.opacity(0.7), in: Circle())
                            }
                        }

                        HStack(spacing: 5) {
                            ForEach(cards.indices, id: \.self) { index in
                                Capsule()
                                    .fill(index <= cardIndex ? accent : Palette.line)
                                    .frame(height: 4)
                            }
                        }

                        StudyCard(card: card, isAnswerVisible: isAnswerVisible)
                            .frame(height: cardHeight)
                            .onTapGesture {
                                guard card.isTwoSided else { return }
                                withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
                                    isAnswerVisible.toggle()
                                }
                            }

                        Spacer(minLength: 0)

                        HStack(spacing: 12) {
                            DeckActionButton(title: "Tekrarla", icon: "arrow.uturn.left", color: Palette.ink) {
                                studyStore.mark(card, known: false)
                                advance()
                            }
                            DeckActionButton(title: "Biliyorum", icon: "checkmark", color: accent) {
                                studyStore.mark(card, known: true)
                                advance()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, topInset)
                    .padding(.bottom, bottomInset)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                } else {
                    VStack(spacing: 0) {
                        HStack {
                            Button(action: { dismiss() }) {
                                Label("Geri", systemImage: "chevron.left")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(Palette.ink)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 11)
                                    .background(.white.opacity(0.78), in: Capsule())
                            }
                            Spacer()
                        }
                        Spacer()
                        ContentUnavailableView("Henüz kart yok", systemImage: "rectangle.stack.badge.plus", description: Text("Bu derse ilk notunu ekleyebilirsin."))
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, topInset)
                    .padding(.bottom, bottomInset)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $isEditing) {
            if let currentCard {
                EditCardSheet(card: currentCard)
                    .presentationDetents([.large])
            }
        }
    }

    private func advance() {
        guard !cards.isEmpty else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            cardIndex = (cardIndex + 1) % cards.count
            isAnswerVisible = false
        }
    }
}

private struct StudyCard: View {
    let card: Flashcard
    let isAnswerVisible: Bool

    var body: some View {
        Group {
            if card.isTwoSided {
                ZStack {
                    CardFace(
                        eyebrow: card.topic,
                        title: card.prompt,
                        helper: "Cevabı görmek için dokun",
                        color: card.subject.color,
                        symbol: "questionmark"
                    )
                    .opacity(isAnswerVisible ? 0 : 1)

                    CardFace(
                        eyebrow: "NOT · \(card.subject.title.uppercased())",
                        title: card.note,
                        helper: "Soruyu yeniden görmek için dokun",
                        color: card.subject.color,
                        symbol: "text.quote"
                    )
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .opacity(isAnswerVisible ? 1 : 0)
                }
                .rotation3DEffect(.degrees(isAnswerVisible ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            } else {
                CardFace(
                    eyebrow: "MADDE · \(card.topic.uppercased())",
                    title: card.note,
                    helper: "Bu kart tek yüzlü · Soru-cevap için Düzenle'ye dokun",
                    color: card.subject.color,
                    symbol: "text.alignleft"
                )
            }
        }
        .animation(.spring(response: 0.42, dampingFraction: 0.82), value: isAnswerVisible)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(card.isTwoSided && !isAnswerVisible ? card.prompt : card.note)
        .accessibilityHint(card.isTwoSided ? "Kartı çevirmek için çift dokunun" : "Bu kart tek yüzlü")
    }
}

private struct CardFace: View {
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
                Image(systemName: symbol)
                    .font(.headline)
            }
            .foregroundStyle(color)

            ScrollView(showsIndicators: true) {
                Text(title)
                    .font(.system(size: 20, weight: .semibold, design: .serif))
                    .foregroundStyle(Palette.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
            }
            .frame(maxHeight: .infinity)
            HStack(spacing: 7) {
                Image(systemName: "hand.tap.fill")
                Text(helper)
            }
            .font(.caption.weight(.medium))
            .foregroundStyle(Palette.warmGray)
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
        .overlay(RoundedRectangle(cornerRadius: 32, style: .continuous).stroke(Palette.line.opacity(0.8), lineWidth: 1))
        .shadow(color: Palette.ink.opacity(0.11), radius: 20, y: 11)
    }
}

private struct DeckActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .foregroundStyle(.white)
                .background(color, in: Capsule())
        }
    }
}

private struct ProgressViewScreen: View {
    @EnvironmentObject private var studyStore: StudyStore

    private var allKnown: Int { studyStore.allCards.filter(studyStore.isKnown).count }

    var body: some View {
        NavigationStack {
            ZStack {
                PaperBackground()
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        Text("İlerlemen")
                            .font(.system(size: 34, weight: .bold, design: .serif))
                        Text("Hedef kusursuzluk değil; düzenli karşılaşma.")
                            .font(.subheadline)
                            .foregroundStyle(Palette.warmGray)

                        HStack(spacing: 18) {
                            ZStack {
                                Circle().stroke(Palette.line, lineWidth: 11)
                                Circle()
                                    .trim(from: 0, to: studyStore.allCards.isEmpty ? 0 : Double(allKnown) / Double(studyStore.allCards.count))
                                    .stroke(Palette.ink, style: StrokeStyle(lineWidth: 11, lineCap: .round))
                                    .rotationEffect(.degrees(-90))
                                Text("\(allKnown)")
                                    .font(.title2.weight(.bold))
                            }
                            .frame(width: 94, height: 94)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("öğrenilen kart")
                                    .font(.headline)
                                Text("\(studyStore.allCards.count) kartın içinden")
                                    .font(.subheadline)
                                    .foregroundStyle(Palette.warmGray)
                            }
                        }
                        .padding(20)
                        .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 24, style: .continuous))

                        ForEach(Subject.allCases) { subject in
                            SubjectRow(progress: studyStore.progress(for: subject))
                        }
                    }
                    .padding(20)
                }
            }
        }
    }
}

private struct SubjectRow: View {
    let progress: SubjectProgress

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: progress.subject.icon)
                .font(.headline)
                .foregroundStyle(progress.subject.color)
                .frame(width: 44, height: 44)
                .background(progress.subject.paleColor, in: Circle())
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(progress.subject.title)
                        .font(.headline)
                        .foregroundStyle(Palette.ink)
                    Spacer()
                    Text("\(progress.known)/\(progress.total)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Palette.warmGray)
                }
                ProgressView(value: progress.fraction)
                    .tint(progress.subject.color)
            }
        }
        .padding(16)
        .background(.white.opacity(0.74), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).stroke(Palette.line.opacity(0.65), lineWidth: 1))
    }
}

private struct AddCardSheet: View {
    @EnvironmentObject private var studyStore: StudyStore
    @Environment(\.dismiss) private var dismiss
    @State private var subject: Subject = .history
    @State private var topic = ""
    @State private var prompt = ""
    @State private var note = ""
    @State private var isTwoSided = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Ders") {
                    Picker("Ders", selection: $subject) {
                        ForEach(Subject.allCases) { subject in
                            Text(subject.title).tag(subject)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Kartın tipi") {
                    Toggle("Soru-cevap kartı", isOn: $isTwoSided)
                    Text(isTwoSided ? "Ön yüzde soru, arka yüzde not görünür." : "Not tek yüzde, aynen görünür.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Section("Madde · aynen") {
                    TextField("Konu (isteğe bağlı)", text: $topic)
                    TextEditor(text: $note)
                        .frame(minHeight: 150)
                    Text("Bu alana PDF'deki maddeyi kısaltmadan yaz. Kartın arka yüzünde aynen görünür.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                if isTwoSided {
                    Section("Kartın ön yüzü") {
                        TextField("Hatırlatma sorusu", text: $prompt, axis: .vertical)
                            .lineLimit(2...4)
                    }
                }
            }
            .navigationTitle("Yeni kart")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç", action: dismiss.callAsFunction)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        studyStore.addCard(subject: subject, topic: topic, prompt: prompt, note: note, isTwoSided: isTwoSided)
                        dismiss()
                    }
                    .disabled(note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || (isTwoSided && prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty))
                }
            }
        }
    }
}

private struct EditCardSheet: View {
    @EnvironmentObject private var studyStore: StudyStore
    @Environment(\.dismiss) private var dismiss
    let card: Flashcard

    @State private var subject: Subject
    @State private var topic: String
    @State private var prompt: String
    @State private var note: String
    @State private var isTwoSided: Bool

    init(card: Flashcard) {
        self.card = card
        _subject = State(initialValue: card.subject)
        _topic = State(initialValue: card.topic)
        _prompt = State(initialValue: card.prompt)
        _note = State(initialValue: card.note)
        _isTwoSided = State(initialValue: card.isTwoSided)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Ders") {
                    Picker("Ders", selection: $subject) {
                        ForEach(Subject.allCases) { subject in
                            Text(subject.title).tag(subject)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Kartın tipi") {
                    Toggle("Soru-cevap kartı", isOn: $isTwoSided)
                    Text(isTwoSided ? "Kart çevrilince notun tam metni görünür." : "Kartın tek yüzünde notun tam metni görünür.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Section("Not metni · aynen") {
                    TextField("Konu (isteğe bağlı)", text: $topic)
                    TextEditor(text: $note)
                        .frame(minHeight: 150)
                }
                if isTwoSided {
                    Section("Ön yüz sorusu") {
                        TextField("Hatırlatma sorusu", text: $prompt, axis: .vertical)
                            .lineLimit(2...4)
                    }
                }
            }
            .navigationTitle("Kartı düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Vazgeç", action: dismiss.callAsFunction)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        studyStore.updateCard(
                            Flashcard(
                                id: card.id,
                                subject: subject,
                                topic: topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Kendi notum" : topic.trimmingCharacters(in: .whitespacesAndNewlines),
                                prompt: prompt.trimmingCharacters(in: .whitespacesAndNewlines),
                                note: note.trimmingCharacters(in: .whitespacesAndNewlines),
                                isTwoSided: isTwoSided,
                                isFromUser: card.isFromUser
                            )
                        )
                        dismiss()
                    }
                    .disabled(note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || (isTwoSided && prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty))
                }
            }
        }
    }
}

private struct NoteRule: View {
    var body: some View {
        HStack(spacing: 8) {
            Rectangle().fill(Palette.line).frame(height: 1)
            Circle().fill(Palette.line).frame(width: 5, height: 5)
            Rectangle().fill(Palette.line).frame(height: 1)
        }
    }
}

private struct PaperBackground: View {
    var body: some View {
        Palette.paper
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
