import Foundation

internal struct FileHandleOutputStream: TextOutputStream {
    private let fileHandle: FileHandle
    let encoding: String.Encoding

    init(_ fileHandle: FileHandle, encoding: String.Encoding = .utf8) {
        self.fileHandle = fileHandle
        self.encoding = encoding
    }

    mutating func write(_ string: String) {
        if let data = string.data(using: encoding) {
            fileHandle.write(data)
        }
    }
}


public protocol Player {
    init()

    func cardsWereRevealed(event: CardReveal) async
    func turnDidOccur(event: Turn) async
    func doTurn(event: TurnRequest) async -> Action
    func beginRound(event: RoundStart) async
}

extension Player {
    public static func main() async throws {
        let cpu = Self()

        var stderr = FileHandleOutputStream(FileHandle.standardError)

        for try await line in FileHandle.standardInput.bytes.lines {
            let event: Event
            do {
                guard let data = line.data(using: .utf8) else {
                    // This can never happen, because FileHandle.standardInput.bytes.lines
                    // already processes the input as UTF-8
                    fatalError("Cannot convert \(line) to data")
                }
                event = try JSONDecoder().decode(Event.self, from: data)
            } catch {
                print(error, to: &stderr)
                break
            }

            switch event.type {
            case .roundStart:
                guard let details = event.roundStart else {
                    print("Begin round event without begin round details", to: &stderr)
                    break
                }
                await cpu.beginRound(event: details)
            case .cardReveal:
                guard let details = event.cardReveal else {
                    print("Card reveal event without card reveal details", to: &stderr)
                    break
                }
                await cpu.cardsWereRevealed(event: details)
            case .turn:
                guard let details = event.turn else {
                    print("Turn event without turn details", to: &stderr)
                    break
                }
                await cpu.turnDidOccur(event: details)
            case .requestForTurn:
                guard let details = event.turnRequest else {
                    print("Request for turn event without request for turn details", to: &stderr)
                    break
                }
                let turn = await cpu.doTurn(event: details)

                do {
                    let data = try JSONEncoder().encode(turn)

                    guard let s = String(bytes: data, encoding: .utf8) else {
                        print("Cannot convert turn to UTF-8 string", to: &stderr)
                        break
                    }

                    print("will print \(s)", to: &stderr)
                    print(s)
                    fflush(stdout)
                }
            }
        }
    }
}
