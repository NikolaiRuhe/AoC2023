import Testing
@testable import AdventOfCode


struct Day01Tests {
  typealias TestDay = Day01

  let testData = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

  @Test func testPart1() async throws {
    let challenge = TestDay(data: testData)
    #expect(String(describing: challenge.part1()) == "142")
  }

  @Test func testPart1_originalData() async throws {
    let challenge = TestDay()
    #expect(String(describing: challenge.part1()) == "54561")
  }

  let testData2 = """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """

  @Test func testPart2() async throws {
    let challenge = TestDay(data: testData2)
    #expect(String(describing: challenge.part2()) == "281")
  }

  @Test func testPart2_originalData() async throws {
    let challenge = TestDay()
    #expect(String(describing: challenge.part2()) == "unknown result")
  }
}
