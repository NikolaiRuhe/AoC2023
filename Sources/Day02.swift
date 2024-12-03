import Algorithms

struct Day02: AdventDay {
  var data: String

  var games: [Game] {
    data.split(separator: "\n").map { Game(line: $0) }
  }

  func part1() -> Any {
    games.filter { game in
      game.samples.allSatisfy { $0.isValid }
    }.reduce(0) {
      $0 + $1.id
    }
  }

  func part2() -> Any {
    games
      .map { $0.minimum.power }
      .reduce(0, +)
  }
}

struct Game {
  var id: Int
  var samples: [Sample]
  init(line: Substring) {
    let components = line.split(separator: /:|;/)
    let game = components[0].wholeMatch(of: /Game (?<id>\d+)/)!
    id = Int(game.id)!
    samples = components
      .dropFirst()
      .map { Sample($0) }
  }

  var minimum: Sample {
    samples.reduce(.init()) {
      var result = $0
      result.red =   max($0.red,   $1.red)
      result.green = max($0.green, $1.green)
      result.blue =  max($0.blue,  $1.blue)
      return result
    }
  }

  struct Sample {
    var red: Int = 0
    var green: Int = 0
    var blue: Int = 0

    var power: Int { red * green * blue }

    init() {}
    init(_ string: Substring) {
      let matches = string.matches(of: /(?<count>\d+)\s+(?<name>\w+)/)
      for match in matches {
        switch match.name {
        case "red":   red   = Int(match.count)!
        case "green": green = Int(match.count)!
        case "blue":  blue  = Int(match.count)!
        default: fatalError("unexpected input: \(match.name)")
        }
      }
    }

    var isValid: Bool {
      red <= 12 && green <= 13 && blue <= 14
    }
  }
}
