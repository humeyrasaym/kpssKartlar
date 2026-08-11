import Foundation

/// A short, relationship-based study activity. A learner places each prompt
/// into the correct group instead of only recalling a single isolated fact.
struct AquariumTour: Identifiable, Hashable {
    let id: String
    let courseID: String
    let title: String
    let subtitle: String
    let instruction: String
    let iconName: String
    let groups: [AquariumGroup]
    let challenges: [AquariumChallenge]
}

struct AquariumGroup: Identifiable, Hashable {
    let id: String
    let title: String
    let detail: String
}

struct AquariumChallenge: Identifiable, Hashable {
    let id: String
    let prompt: String
    let correctGroupID: String
    let explanation: String
}
