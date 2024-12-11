import Algorithms

// https://adventofcode.com/2023/day/5
struct Day05: AdventDay {
  static let testData = """
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """

  static var expectedTestResult1:   String { "35" }
  static var expectedProperResult1: String { "662197086" }
  static var expectedTestResult2:   String { "46" }
  static var expectedProperResult2: String { "52510809" }

  var seeds: [Int]
  var map: MultiMap

  init(data: String) {
    let chunks = data.split(separator: "\n\n").map {
      $0.split(separator: "\n")
    }

    self.seeds = chunks[0][0]
      .split(separator: /:|\s+/).dropFirst()
      .map { Int($0)! }

    self.map = MultiMap(chunks.dropFirst())
  }

  func part1() -> Any {
    seeds.map { map[$0] }.min() ?? 0
  }

  var seedRanges: [Range<Int>] {
    seeds
      .evenlyChunked(in: seeds.count / 2)
      .map { $0.first! ..< $0.first! + $0.last! }
  }

  func part2_slowImpl() -> Any {
    var minLocation = map[seeds[0]]

    for chunk in seedRanges {
      for i in chunk {
        minLocation = min(minLocation, map[i])
      }
    }

    return minLocation
  }

  func part2() -> Any {
    seedRanges
      .reduce(into: map[seeds[0]]) {
        map.minimumLocation(
          in: $1,
          subMapIndex: 0,
          minimum: &$0
        )
      }
  }
}

extension Day05 {
  struct MultiMap {
    let maps: [SubMap]

    init(_ chunks: [[Substring]].SubSequence) {
      self.maps = chunks.map { SubMap($0) }
      assert(maps.reduce("seed") { ($1.source == $0) ? $1.destination : "error" } == "location")
    }

    subscript(_ source: Int) -> Int {
      maps.reduce(source) { $1[$0] }
    }

    func minimumLocation(in range: Range<Int>, subMapIndex: Int, minimum: inout Int) {
      guard subMapIndex != maps.endIndex else {
        assert(!range.isEmpty)
        if minimum > range.lowerBound {
          minimum = range.lowerBound
        }
        return
      }

      func recursiveSearch(_ range: Range<Int>) {
        guard !range.isEmpty else { return }
        minimumLocation(
          in: range,
          subMapIndex: subMapIndex + 1,
          minimum: &minimum
        )
      }

      var range = range
      let subMap = maps[subMapIndex]
      var transforms = subMap.transforms.makeIterator()

      while !range.isEmpty {
        guard let transform = transforms.next() else { break }
        if range.isAbove(transform.input) { continue }
        if transform.input.isAbove(range) { break }

        assert(transform.input.overlaps(range))

        if range.lowerBound < transform.input.lowerBound {
          recursiveSearch(range.lowerBound ..< transform.input.lowerBound)
          range = transform.input.lowerBound ..< range.upperBound
        }

        recursiveSearch(range.clamped(to: transform.input).shifted(by: transform.offset))
        range = min(transform.input.upperBound, range.upperBound) ..< range.upperBound
      }

      if !range.isEmpty { recursiveSearch(range) }
    }
  }
}

extension Day05.MultiMap {

  struct SubMap {
    var source: String
    var destination: String
    var transforms: [RangeTransform]

    init(_ lines: [Substring]) {
      let components = lines[0].split(separator: #/-to-| /#)
      self.source = String(components[0])
      self.destination = String(components[1])
      self.transforms = lines
        .dropFirst()
        .map(RangeTransform.init)
        .sorted { $0.input.lowerBound < $1.input.lowerBound }

      assert(transforms.combinations(ofCount: 2).allSatisfy { !$0.first!.input.overlaps($0.last!.input) })
      assert(transforms.combinations(ofCount: 2).allSatisfy { !$0.first!.output.overlaps($0.last!.output) })
    }

    subscript(_ source: Int) -> Int {
      transforms
        .first(where: { $0.input.contains(source) })
        .map { source + $0.offset } ?? source
    }
  }
}

extension Day05.MultiMap.SubMap {

  struct RangeTransform {
    var input: Range<Int>
    var offset: Int
    var output: Range<Int> { input.shifted(by: offset) }

    init(_ string: Substring) {
      let parts = string
        .split(separator: " ")
        .map { Int($0)! }
      self.input = parts[1] ..< parts[1] + parts[2]
      self.offset = parts[0] - parts[1]
    }
  }
}

extension Range<Int> {
  func shifted(by offset: Int) -> Self {
    self.lowerBound + offset ..< self.upperBound + offset
  }

  func isAbove(_ other: Self) -> Bool {
    lowerBound >= other.upperBound
  }
}
