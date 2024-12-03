import Algorithms

struct Day04: AdventDay {
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
