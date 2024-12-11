import Algorithms

// https://adventofcode.com/2023/day/3
struct Day03: AdventDay {
  static let testData = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

  static var expectedTestResult1:   String { "4361" }
  static var expectedProperResult1: String { "522726" }
  static var expectedTestResult2:   String { "467835" }
  static var expectedProperResult2: String { "81721933" }

  var data: String

  func part1() -> Any {
    Grid(data).sumOfPartNumbers
  }

  func part2() -> Any {
    Grid(data).sumOfGearRatios
  }

  struct Grid {
    var rows: [Substring]

    init(_ input: String) {
      let rows = input.split(separator: "\n")
      self.rows = rows
    }

    var sumOfPartNumbers: Int {
      rows
        .indices
        .flatMap { partNumbers(atRow: $0) }
        .reduce(0, +)
    }

    func partNumbers(atRow rowIndex: Int) -> [Int] {
      rows[rowIndex]
        .matches(of: /\d+/)
        .filter {
          isPartNumber(
            atRow: rowIndex,
            range: rows[rowIndex].characterRange(of: $0.range)
          )
        }
        .map { Int($0.0)! }
    }

    func isPartNumber(atRow rowIndex: Int, range: Range<Int>) -> Bool {
      rowsAround(rowIndex: rowIndex)
        .contains { row in
          row[range, extendBy: 1]
            .contains { !($0.isNumber || $0 == ".") }
        }
    }

    var sumOfGearRatios: Int {
      rows
        .indices
        .flatMap { gearRatios(atRow: $0) }
        .reduce(0, +)
    }

    func gearRatios(atRow rowIndex: Int) -> [Int] {
      rows[rowIndex]
        .matches(of: /\*/)
        .map {
          let col = rows[rowIndex].characterRange(of: $0.range).lowerBound
          let numbers = findNumbersTouching(rowIndex: rowIndex, column: col)
          return numbers.count == 2 ? numbers[0] * numbers[1] : 0
        }
    }

    func findNumbersTouching(rowIndex: Int, column: Int) -> [Int] {
      let starRange = column - 1 ... column + 1
      return rowsAround(rowIndex: rowIndex)
        .flatMap { row in
          row
            .matches(of: /\d+/)
            .filter { match in
              row.characterRange(of: match.range).overlaps(starRange)
            }
            .map { Int($0.0)! }
        }
    }

    func rowsAround(rowIndex: Int) -> Array<Substring>.SubSequence {
      rows[max(rows.startIndex, rowIndex - 1) ... min(rows.endIndex - 1, rowIndex + 1)]
    }
  }
}

extension Substring {
  func characterRange(of range: Range<Index>) -> Range<Int> {
    let start = self[..<range.lowerBound].count
    let count = self[range].count
    return start ..< start + count
  }

  subscript(range: Range<Int>, extendBy extendBy: Int = 0) -> Substring {
    let start = Swift.max(0, range.lowerBound - extendBy)
    return dropFirst(start).prefix(range.upperBound + extendBy - start)
  }
}
