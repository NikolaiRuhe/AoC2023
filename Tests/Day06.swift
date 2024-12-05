import Testing
@testable import AdventOfCode


struct Day06Tests {
  typealias TestDay = Day06

  let testData = """
    Time:      7  15   30
    Distance:  9  40  200
    """

  @Test func testPart1() async throws {
    let challenge = TestDay(data: testData)
    #expect(String(describing: challenge.part1()) == "288")
  }

  @Test func testPart1_originalData() async throws {
    let challenge = TestDay()
    #expect(String(describing: challenge.part1()) == "293046")
  }

  @Test func testPart2() async throws {
    let challenge = TestDay(data: testData)
    #expect(String(describing: challenge.part2()) == "71503")
  }

  @Test func testPart2_originalData() async throws {
    let challenge = TestDay()
    #expect(String(describing: challenge.part2()) == "35150181")
  }
}
