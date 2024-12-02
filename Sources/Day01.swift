import Algorithms

struct Day01: AdventDay {
  var data: String

  func part1() -> Any {
    var result = 0

    var first: Int? = nil
    var last: Int? = nil

    for character in data {
      if character.isNumber {
        guard let value = Int(String(character)) else { continue }
        if first == nil {
          first = value
        } else {
          last = value
        }
      } else if character.isNewline {
        result += 10 * (first ?? 0) + (last ?? first ?? 0)
        first = nil
        last = nil
      }
    }

    result += 10 * (first ?? 0) + (last ?? first ?? 0)
    return result
  }

  func part2() -> Any {
    let numbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    func convert(_ input: Substring) -> Int {
      let string = String(input)
      return Int(string) ?? numbers.firstIndex(of: string)! + 1
    }

    let regex = /one|two|three|four|five|six|seven|eight|nine|\d/
    return data.split(separator: "\n").map { line in
      let matches = line.matches(of: regex)
      return matches.isEmpty ? 0 : 10 * convert(matches.first!.0) + convert(matches.last!.0)
    }.reduce(0, +)
  }
}
