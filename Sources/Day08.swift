import Algorithms

// Haunted Wasteland
// https://adventofcode.com/2023/day/8
struct Day08: AdventDay {
  static let testData = """
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """

  static let testData2 = """
  LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)
  """

  static var expectedTestResult1:   String { "6" }
  static var expectedProperResult1: String { "16531" }
  static var expectedTestResult2:   String { "6" }
  static var expectedProperResult2: String { "24035773251517" }

  var sequence: BitArray
  var rules: [(l: UInt16, r: UInt16)]
  var start: UInt16?
  var end: UInt16?
  var startNodes: [UInt16]
  var endNodes: Set<UInt16>

  init(data: String) {
    let chunks = data
      .split(separator: "\n\n")
      .map { $0.split(separator: "\n") }

    self.sequence = BitArray(
      chunks[0][0]
        .filter { $0 == "R" || $0 == "L" }
        .map { $0 == "L" }
    )

    let map = Dictionary(
      uniqueKeysWithValues: chunks[1]
        .enumerated()
        .map { ($1.prefix(3), UInt16($0)) }
      )
    self.start = map["AAA"]
    self.end = map["ZZZ"]

    self.startNodes =     map.keys.filter { $0.last == "A" }.map { map[$0]! }
    self.endNodes   = Set(map.keys.filter { $0.last == "Z" }.map { map[$0]! })

    self.rules = chunks[1]
      .map { (map[$0.dropFirst(7).prefix(3)]!, map[$0.dropFirst(12).prefix(3)]!) }
  }

  func pathLength(startingAt start: UInt16, endingAt endings: Set<UInt16>) -> Int {
    var count = 0
    var node = start
    while true {
      for dir in sequence {
        if endings.contains(node) { return count }
        let rule = rules[Int(node)]
        node = dir ? rule.l : rule.r
        count += 1
      }
    }
  }

  func part1() -> Any {
    pathLength(startingAt: start!, endingAt: endNodes)
  }

  func part2() -> Any {
    startNodes
      .map { pathLength(startingAt: $0, endingAt: endNodes) }
      .reduce(1, lcm)
  }
}

fileprivate func gcd(_ lhs: Int, _ rhs: Int) -> Int {
  var a = lhs
  var b = rhs
  while b != 0 { (a, b) = (b, a % b) }
  return a
}

fileprivate func lcm(_ lhs: Int, _ rhs: Int) -> Int { lhs * rhs / gcd(lhs, rhs) }
