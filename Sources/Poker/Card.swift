import Foundation

public enum Rank: Int, Codable, CaseIterable, CustomStringConvertible, Sendable {
    case ace = 1
    case two, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king

    public var description: String {
        switch self {
        case .ace: return "A"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        default: return "\(self.rawValue)"
        }
    }
}

public enum Suit: String, Codable, CaseIterable, CustomStringConvertible, Sendable {
    case spades, hearts, diamonds, clubs

    public var description: String {
        switch self {
        case .spades: return "♠︎"
        case .hearts: return "♡"
        case .diamonds: return "♢"
        case .clubs: return "♣︎"
        }
    }
}

public struct Card: Codable, Sendable {
    public let suit: Suit
    public let rank: Rank
}
