import Algorithms

// https://adventofcode.com/2023/day/6
struct Day06: AdventDay {
  static let testData = """
    Time:      7  15   30
    Distance:  9  40  200
    """

  static var expectedTestResult1:   String { "288" }
  static var expectedProperResult1: String { "293046" }
  static var expectedTestResult2:   String { "71503" }
  static var expectedProperResult2: String { "35150181" }

  struct Race {
    var time: Int
    let distance: Int

    func wins(buttonPressTime: Int) -> Bool {
      buttonPressTime * (time - buttonPressTime) > distance
    }

    var variantsToWin_naïve: Int {
      (1..<time).count(where: { wins(buttonPressTime: $0) })
    }

    var variantsToWin: Int {
      let start = binarySearch(in:     0 ..< time, forFirst: true)
      let end   = binarySearch(in: start ..< time, forFirst: false)
      return end - start
    }

    func binarySearch(in times: Range<Int>, forFirst win: Bool) -> Int {
      var start = times.lowerBound
      var end   = times.upperBound
      while start < end {
        let mid = start + (end - start) / 2
        if wins(buttonPressTime: mid) == win {
          end = mid
        } else {
          start = mid + 1
        }
      }
      return start
    }
  }

  var races: [Race]
  var theRace: Race

  init(data: String) {
    let parts = data.split(separator: "\n").map {
      $0.split(separator: /:|\s+/).dropFirst().map { Int($0)! }
    }
    self.races = zip(parts[0], parts[1]).map { Race(time: $0, distance: $1) }
    self.theRace = Race(
      time: Int(races.map { String($0.time) }.joined())!,
      distance: Int(races.map { String($0.distance) }.joined())!
    )
  }

  func part1() -> Any {
    races.map { $0.variantsToWin }.reduce(1, *)
  }

  func part2() -> Any {
    theRace.variantsToWin
  }
}
