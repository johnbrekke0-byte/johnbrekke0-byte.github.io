import Foundation

enum CharacterCategory: String, Codable, CaseIterable {
    case animated = "Animated"
    case celebrities = "Celebrities"
    case accents = "Accents"

    var emoji: String {
        switch self {
        case .animated: return "🎬"
        case .celebrities: return "⭐️"
        case .accents: return "🌍"
        }
    }

    var color: String {
        switch self {
        case .animated: return "purple"
        case .celebrities: return "blue"
        case .accents: return "green"
        }
    }
}

enum Difficulty: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"

    var xpReward: Int {
        switch self {
        case .beginner: return 10
        case .intermediate: return 20
        case .advanced: return 35
        }
    }

    var requiredScore: Int {
        switch self {
        case .beginner: return 50
        case .intermediate: return 65
        case .advanced: return 75
        }
    }
}

struct VoiceTrait: Identifiable, Codable {
    let id: UUID
    let icon: String
    let name: String
    let description: String

    init(icon: String, name: String, description: String) {
        self.id = UUID()
        self.icon = icon
        self.name = name
        self.description = description
    }
}

struct PracticePhrase: Identifiable, Codable {
    let id: UUID
    let text: String
    let hint: String?

    init(text: String, hint: String? = nil) {
        self.id = UUID()
        self.text = text
        self.hint = hint
    }
}

struct ImpressionCharacter: Identifiable, Codable {
    let id: UUID
    let name: String
    let category: CharacterCategory
    let emoji: String
    let difficulty: Difficulty
    let unlockXP: Int
    let voiceTraits: [VoiceTrait]
    let phrases: [PracticePhrase]
    let pitchRange: PitchRange
    let speakingRate: SpeakingRate

    struct PitchRange: Codable {
        let low: Float
        let high: Float
        let description: String
    }

    enum SpeakingRate: String, Codable {
        case slow, normal, fast
    }
}

extension ImpressionCharacter {
    static let catalog: [ImpressionCharacter] = [
        // ANIMATED
        ImpressionCharacter(
            id: UUID(),
            name: "Kermit the Frog",
            category: .animated,
            emoji: "🐸",
            difficulty: .beginner,
            unlockXP: 0,
            voiceTraits: [
                VoiceTrait(icon: "waveform", name: "Nasally whine", description: "Push air through your nose while speaking"),
                VoiceTrait(icon: "mouth", name: "Soft and earnest", description: "Speak gently, as if slightly overwhelmed"),
                VoiceTrait(icon: "music.note", name: "Rising inflection", description: "Your voice rises toward the end of sentences"),
            ],
            phrases: [
                PracticePhrase(text: "Hi-ho! Kermit the Frog here.", hint: "Emphasize 'Hi-ho' with a nasal whine"),
                PracticePhrase(text: "It's not easy being green.", hint: "Slow and wistful, with a slight sigh"),
                PracticePhrase(text: "Yaaay!", hint: "Enthusiastic but slightly strained"),
            ],
            pitchRange: .init(low: 180, high: 380, description: "Medium-high, nasally"),
            speakingRate: .normal
        ),
        ImpressionCharacter(
            id: UUID(),
            name: "Yoda",
            category: .animated,
            emoji: "🟢",
            difficulty: .intermediate,
            unlockXP: 50,
            voiceTraits: [
                VoiceTrait(icon: "waveform.path", name: "Raspy and aged", description: "Speak from the back of your throat, slightly strained"),
                VoiceTrait(icon: "slowmo", name: "Deliberate pace", description: "Pause often, every word has weight"),
                VoiceTrait(icon: "arrow.triangle.2.circlepath", name: "Reversed syntax", description: "Rearrange sentences: subject last"),
            ],
            phrases: [
                PracticePhrase(text: "Do or do not. There is no try.", hint: "Long pause after 'do not'"),
                PracticePhrase(text: "Luminous beings are we, not this crude matter.", hint: "Tap yourself on the pause before 'not'"),
                PracticePhrase(text: "Fear is the path to the dark side.", hint: "Gravely and slow"),
            ],
            pitchRange: .init(low: 100, high: 200, description: "Low and gravelly"),
            speakingRate: .slow
        ),
        ImpressionCharacter(
            id: UUID(),
            name: "Shrek",
            category: .animated,
            emoji: "🟩",
            difficulty: .intermediate,
            unlockXP: 50,
            voiceTraits: [
                VoiceTrait(icon: "waveform", name: "Scottish brogue", description: "Roll your R's, flatten your vowels"),
                VoiceTrait(icon: "speaker.wave.3", name: "Gruff and loud", description: "Speak from your chest with force"),
                VoiceTrait(icon: "face.smiling", name: "Annoyed warmth", description: "Sound grumpy but secretly endearing"),
            ],
            phrases: [
                PracticePhrase(text: "That'll do, Donkey. That'll do.", hint: "Tired and exasperated"),
                PracticePhrase(text: "Ogres are like onions.", hint: "Proud and defensive"),
                PracticePhrase(text: "Get out of my swamp!", hint: "Loud and Scottish"),
            ],
            pitchRange: .init(low: 80, high: 180, description: "Deep, Scottish accent"),
            speakingRate: .normal
        ),
        ImpressionCharacter(
            id: UUID(),
            name: "Gollum",
            category: .animated,
            emoji: "👁️",
            difficulty: .advanced,
            unlockXP: 150,
            voiceTraits: [
                VoiceTrait(icon: "waveform.path.ecg", name: "Raspy hiss", description: "Force air out between clenched teeth"),
                VoiceTrait(icon: "person.2", name: "Split personality", description: "Switch between whiny pleading and menacing whisper"),
                VoiceTrait(icon: "sparkles", name: "My precious", description: "Elongate sibilants — 'precious' becomes 'preciousss'"),
            ],
            phrases: [
                PracticePhrase(text: "My precious...", hint: "Breathy, covetous, elongate the S"),
                PracticePhrase(text: "We wants it. We needs it.", hint: "Plural 'we' for self, urgent and desperate"),
                PracticePhrase(text: "Sneaky little hobbitses!", hint: "Nasty and hissing"),
            ],
            pitchRange: .init(low: 150, high: 350, description: "Raspy, varied pitch"),
            speakingRate: .normal
        ),

        // CELEBRITIES
        ImpressionCharacter(
            id: UUID(),
            name: "Arnold Schwarzenegger",
            category: .celebrities,
            emoji: "💪",
            difficulty: .beginner,
            unlockXP: 0,
            voiceTraits: [
                VoiceTrait(icon: "waveform", name: "Austrian accent", description: "Flatten your A's: 'back' becomes 'beck'"),
                VoiceTrait(icon: "speaker.wave.3", name: "Deep and forceful", description: "Speak from your diaphragm with authority"),
                VoiceTrait(icon: "tortoise", name: "Deliberate pace", description: "Punch each syllable clearly"),
            ],
            phrases: [
                PracticePhrase(text: "I'll be back.", hint: "Slow, deliberate, dead serious"),
                PracticePhrase(text: "Hasta la vista, baby.", hint: "Confident, almost casual"),
                PracticePhrase(text: "Get to the choppa!", hint: "Urgent but keep the accent thick"),
            ],
            pitchRange: .init(low: 80, high: 160, description: "Deep, Austrian accent"),
            speakingRate: .slow
        ),
        ImpressionCharacter(
            id: UUID(),
            name: "Christopher Walken",
            category: .celebrities,
            emoji: "🎭",
            difficulty: .advanced,
            unlockXP: 150,
            voiceTraits: [
                VoiceTrait(icon: "pause", name: "Unpredictable pauses", description: "Insert long pauses in... unexpected places"),
                VoiceTrait(icon: "arrow.up.arrow.down", name: "Odd stress patterns", description: "Emphasize random words that don't need it"),
                VoiceTrait(icon: "waveform.path", name: "Breathy delivery", description: "Slight breathiness, like sharing a secret"),
            ],
            phrases: [
                PracticePhrase(text: "I got a fever. And the only prescription is more cowbell.", hint: "Pause after 'fever' and after 'prescription'"),
                PracticePhrase(text: "You're a cantaloupe.", hint: "Say it like it's profound wisdom"),
                PracticePhrase(text: "Surprise me.", hint: "Two words, three pauses"),
            ],
            pitchRange: .init(low: 100, high: 200, description: "Mid-range, breathy"),
            speakingRate: .slow
        ),
        ImpressionCharacter(
            id: UUID(),
            name: "Morgan Freeman",
            category: .celebrities,
            emoji: "🎙️",
            difficulty: .intermediate,
            unlockXP: 80,
            voiceTraits: [
                VoiceTrait(icon: "speaker.wave.3", name: "Rich and resonant", description: "Speak from deep in your chest, let it rumble"),
                VoiceTrait(icon: "waveform", name: "Smooth and unhurried", description: "Never rush. Each word flows into the next"),
                VoiceTrait(icon: "lightbulb", name: "Narrator authority", description: "Sound like you're explaining the meaning of life"),
            ],
            phrases: [
                PracticePhrase(text: "I'm gonna tell you something, and you're gonna listen.", hint: "Warm but unquestionable"),
                PracticePhrase(text: "Hope is a good thing. Maybe the best of things.", hint: "Gentle and wise"),
                PracticePhrase(text: "Some birds aren't meant to be caged.", hint: "Let 'caged' hang in the air"),
            ],
            pitchRange: .init(low: 80, high: 160, description: "Deep, resonant baritone"),
            speakingRate: .slow
        ),
        ImpressionCharacter(
            id: UUID(),
            name: "Owen Wilson",
            category: .celebrities,
            emoji: "😎",
            difficulty: .beginner,
            unlockXP: 30,
            voiceTraits: [
                VoiceTrait(icon: "waveform", name: "Texas drawl", description: "Soften your consonants, stretch your vowels"),
                VoiceTrait(icon: "face.smiling", name: "Laid-back charm", description: "Sound permanently amused and unbothered"),
                VoiceTrait(icon: "sparkles", name: "The 'Wow'", description: "Nasally rising 'wow' — the signature move"),
            ],
            phrases: [
                PracticePhrase(text: "Wow.", hint: "Nasally, rising pitch, slight pause before and after"),
                PracticePhrase(text: "That's great, man. That's just... wow.", hint: "Trail off on 'wow'"),
                PracticePhrase(text: "I'm a little bit of a loner.", hint: "Casual and slightly self-aware"),
            ],
            pitchRange: .init(low: 120, high: 220, description: "Mid-range, Texas drawl"),
            speakingRate: .normal
        ),

        // ACCENTS
        ImpressionCharacter(
            id: UUID(),
            name: "British RP",
            category: .accents,
            emoji: "🇬🇧",
            difficulty: .beginner,
            unlockXP: 0,
            voiceTraits: [
                VoiceTrait(icon: "waveform", name: "Non-rhotic", description: "Drop your R's at end of words: 'car' = 'cah'"),
                VoiceTrait(icon: "textformat.abc", name: "Clipped vowels", description: "'Bath' rhymes with 'cloth', not 'cat'"),
                VoiceTrait(icon: "crown", name: "Crisp consonants", description: "Pronounce every T clearly, no flapping"),
            ],
            phrases: [
                PracticePhrase(text: "Frightfully good to see you.", hint: "Drop the R in 'frightfully', clip the T's"),
                PracticePhrase(text: "I beg your pardon?", hint: "'Pardon' = 'pahdon', no R sound"),
                PracticePhrase(text: "One simply does not rush these things.", hint: "Measured and slightly imperious"),
            ],
            pitchRange: .init(low: 150, high: 280, description: "Mid-range, precise"),
            speakingRate: .normal
        ),
        ImpressionCharacter(
            id: UUID(),
            name: "Southern American",
            category: .accents,
            emoji: "🤠",
            difficulty: .beginner,
            unlockXP: 20,
            voiceTraits: [
                VoiceTrait(icon: "tortoise", name: "Slow and warm", description: "Drawl your vowels out like taffy"),
                VoiceTrait(icon: "waveform", name: "Vowel shifting", description: "'I' becomes 'Ah': 'I'm fine' = 'Ahm fahn'"),
                VoiceTrait(icon: "hand.wave", name: "Y'all and ain't", description: "Use regional vocabulary naturally"),
            ],
            phrases: [
                PracticePhrase(text: "Well, bless your heart.", hint: "Sounds sweet, but it's not a compliment"),
                PracticePhrase(text: "Y'all come back now, y'hear?", hint: "Warm and genuine, stretch 'y'all'"),
                PracticePhrase(text: "I'm fixin' to head on down the road.", hint: "'Fixin' to' = about to"),
            ],
            pitchRange: .init(low: 130, high: 250, description: "Mid-range, warm drawl"),
            speakingRate: .slow
        ),
        ImpressionCharacter(
            id: UUID(),
            name: "New York",
            category: .accents,
            emoji: "🗽",
            difficulty: .intermediate,
            unlockXP: 60,
            voiceTraits: [
                VoiceTrait(icon: "bolt", name: "Fast and clipped", description: "Speed it up, no time to waste"),
                VoiceTrait(icon: "waveform.path", name: "Cawfee talk", description: "'Coffee' = 'Cawfee', 'talk' = 'tawk'"),
                VoiceTrait(icon: "arrow.up", name: "Raised vowels", description: "The 'ah' sound moves toward 'aw'"),
            ],
            phrases: [
                PracticePhrase(text: "I'm walkin' here!", hint: "Indignant, fast, raised 'aw' vowel"),
                PracticePhrase(text: "Fuhgeddaboudit.", hint: "One flowing word, accent on 'DED'"),
                PracticePhrase(text: "You talkin' to me?", hint: "Clipped, slightly menacing"),
            ],
            pitchRange: .init(low: 140, high: 300, description: "Mid-range, fast-paced"),
            speakingRate: .fast
        ),
        ImpressionCharacter(
            id: UUID(),
            name: "Australian",
            category: .accents,
            emoji: "🇦🇺",
            difficulty: .intermediate,
            unlockXP: 60,
            voiceTraits: [
                VoiceTrait(icon: "waveform", name: "High Rising Terminal", description: "Statements end with rising inflection, like questions"),
                VoiceTrait(icon: "textformat.abc", name: "Vowel raising", description: "'Day' sounds like 'Die', 'mate' sounds like 'mite'"),
                VoiceTrait(icon: "face.smiling", name: "Relaxed and casual", description: "Everything is abbreviated: arvo, arkie, brekkie"),
            ],
            phrases: [
                PracticePhrase(text: "No worries, mate.", hint: "Rising at the end, very relaxed"),
                PracticePhrase(text: "She'll be right.", hint: "Everything is fine, 'she' = the situation"),
                PracticePhrase(text: "G'day! How ya going?", hint: "'Going' not 'doing' — that's the Aussie way"),
            ],
            pitchRange: .init(low: 150, high: 300, description: "Mid-range, rising inflection"),
            speakingRate: .normal
        ),
    ]
}
