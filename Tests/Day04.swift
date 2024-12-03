import Testing
@testable import AdventOfCode


struct Day04Tests {
  typealias TestDay = Day04

  let testData = """
    Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
    Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
    Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
    Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
    Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
    Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    """

  @Test func testPart1() async throws {
    let challenge = TestDay(data: testData)
    #expect(String(describing: challenge.part1()) == "13")
  }

  @Test func testPart1_originalData() async throws {
    let challenge = TestDay()
    #expect(String(describing: challenge.part1()) == "22897")
  }

  @Test func testPart2() async throws {
    let challenge = TestDay(data: testData)
    #expect(String(describing: challenge.part2()) == "30")
  }

  @Test func testPart2_originalData() async throws {
    let challenge = TestDay()
    #expect(String(describing: challenge.part2()) == "5095824")
  }
}
