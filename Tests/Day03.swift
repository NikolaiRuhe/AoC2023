import Testing
@testable import AdventOfCode


struct Day03Tests {
  typealias TestDay = Day03

  let testData = """
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

  @Test func testPart1() async throws {
    let challenge = TestDay(data: testData)
    #expect(String(describing: challenge.part1()) == "4361")
  }

  @Test func testPart1_originalData() async throws {
    let challenge = TestDay()
    #expect(String(describing: challenge.part1()) == "522726")
  }

  @Test func testPart2() async throws {
    let challenge = TestDay(data: testData)
    #expect(String(describing: challenge.part2()) == "467835")
  }

  @Test func testPart2_originalData() async throws {
    let challenge = TestDay()
    #expect(String(describing: challenge.part2()) == "81721933")
  }
}
