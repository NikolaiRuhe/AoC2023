import Algorithms

// https://adventofcode.com/2023/day/7
struct Day07: AdventDay {
  static let testData = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

  static var expectedTestResult1:   String { "6440" }
  static var expectedProperResult1: String { "250254244" }
  static var expectedTestResult2:   String { "5905" }
  static var expectedProperResult2: String { "250087440" }

  var data: String

  func part1() -> Any {
    data
      .split(separator: "\n")
      .map(Hand.init)
      .sorted()
      .enumerated()
      .map { ($0 + 1) * $1.bid }
      .reduce(0, +)
  }

  func part2() -> Any {
    data
      .split(separator: "\n")
      .map { $0.replacing("J", with: "1") }
      .map(Hand.init)
      .sorted()
      .enumerated()
      .map { ($0 + 1) * $1.bid }
      .reduce(0, +)
  }

  struct Hand: Comparable {
    var cards: String
    var rank: Rank
    var bid: Int

    init(_ input: Substring) {
      self.cards = String(input.prefix(5).map { $0.encode })
      self.rank = Rank(cards: self.cards)
      self.bid = Int(String(input.dropFirst(6)))!
    }

    static func < (lhs: Day07.Hand, rhs: Day07.Hand) -> Bool {
      guard lhs.rank == rhs.rank else { return lhs.rank < rhs.rank }
      return lhs.cards < rhs.cards
    }

    enum Rank: Int, Comparable {
      case highCard
      case onePair
      case twoPair
      case threeOfAKind
      case fullHouse
      case fourOfAKind
      case fiveOfAKind

      init(cards: String) {
        var freq = Dictionary(
          uniqueKeysWithValues: Dictionary(grouping: cards, by: \.self).map { ($0, $1.count) }
        )

        let jokers = freq["1"] ?? 0
        if jokers == 5 { self = .fiveOfAKind; return }

        freq["1"] = nil
        let m = freq.max(by: { $0.value < $1.value })!.key
        freq[m, default: 0] += jokers

        let counts = freq
          .values
          .sorted()
          .map { String($0) }
          .joined()

        switch counts {
        case "5":     self = .fiveOfAKind
        case "14":    self = .fourOfAKind
        case "23":    self = .fullHouse
        case "113":   self = .threeOfAKind
        case "122":   self = .twoPair
        case "1112":  self = .onePair
        case "11111": self = .highCard
        default:      fatalError()
        }
      }

      static func < (lhs: Day07.Hand.Rank, rhs: Day07.Hand.Rank) -> Bool {
        lhs.rawValue < rhs.rawValue
      }
    }
  }
}

extension Character {
  var encode: Character {
    switch self {
    case "T": "a"
    case "J": "b"
    case "Q": "c"
    case "K": "d"
    case "A": "e"
    default: self
    }
  }
  var decode: Character {
    switch self {
    case "a": "T"
    case "b": "J"
    case "c": "Q"
    case "d": "K"
    case "e": "A"
    default: self
    }
  }
}
