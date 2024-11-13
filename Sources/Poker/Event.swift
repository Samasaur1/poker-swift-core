import Foundation

public struct Event: Codable, Sendable {
    public init(type: EventType, roundStart: RoundStart? = nil, turn: Turn? = nil, turnRequest: TurnRequest? = nil, cardReveal: CardReveal? = nil) {
        self.type = type
        self.roundStart = roundStart
        self.turn = turn
        self.turnRequest = turnRequest
        self.cardReveal = cardReveal
    }

    public enum EventType: String, Codable, Sendable {
        case roundStart
        case turn
        case requestForTurn
        case cardReveal
    }
    public let type: EventType
    public let roundStart: RoundStart?
    public let turn: Turn?
    public let turnRequest: TurnRequest?
    public let cardReveal: CardReveal?
}

public struct RoundStart: Codable, Sendable {
    public init(playerID: Int, cards: Card...) {
        self.init(playerID: playerID, cards: cards)
    }
    public init(playerID: Int, cards: [Card]) {
        self.playerID = playerID
        self.cards = cards
    }

    public let playerID: Int
    public let cards: [Card]
}

public struct Turn: Codable, Sendable {
    public init(playerID: Int, move: Action) {
        self.playerID = playerID
        self.move = move
    }

    public let playerID: Int
    public let move: Action
}

public struct TurnRequest: Codable, Sendable {
    public init() {}
}

public struct CardReveal: Codable, Sendable {
    public init(type: CardRevealType, cards: Card...) {
        self.init(type: type, cards: cards)
    }
    public init(type: CardRevealType, cards: [Card]) {
        self.type = type
        self.cards = cards
    }

    public enum CardRevealType: String, Codable, Sendable {
        case flop
        case turn
        case river
    }
    public let type: CardRevealType
    public let cards: [Card]
}

public enum Action: Codable, Sendable {
    case checkOrCall
    case raise(by: Int)
    case fold
}
