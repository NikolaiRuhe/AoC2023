import Algorithms

// https://adventofcode.com/2023/day/4
struct Day04: AdventDay {
  static let testData = """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """

  static var expectedTestResult1:   String { "13" }
  static var expectedProperResult1: String { "22897" }
  static var expectedTestResult2:   String { "30" }
  static var expectedProperResult2: String { "5095824" }

  var data: String

  var cards: [Card] { data.split(separator: "\n").map(Card.init) }

  struct Card {
    var winCount: Int

    init(_ line: Substring) {
      let components = line.split(separator: /:|\|/)
      let wins = Set(components[1].split(separator: /\s+/).map { Int($0)! })
      let deck = Set(components[2].split(separator: /\s+/).map { Int($0)! })
      self.winCount = wins.intersection(deck).count
    }

    var points: Int { 1 << (winCount - 1) }
  }

  func part1() -> Any {
    cards.map { $0.points }.reduce(0, +)
  }

  func part2() -> Any {
    let cards = self.cards
    var counts = Array<Int>(repeating: 1, count: cards.count)

    return cards
      .enumerated()
      .map { index, card in
        let count = counts[index]
        let range = index + 1 ..< index + 1 + card.winCount
        for i in range { counts[i] += count }
        return count
      }
      .reduce(0, +)
  }
}
