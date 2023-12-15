import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day10Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData1 = """
   -L|F7
   7S-7|
   L|7||
   -L-J|
   L|-JF    
   """
   
   let testData2 = """
   7-F7-
   .FJ|7
   SJLL7
   |F--J
   LJ.LJ
   """
   

  func testPart1() throws {
    let challenge1 = Day10(data: testData1)
    XCTAssertEqual(String(describing: challenge1.part1()), "4")
     
     let challenge2 = Day10(data: testData2)
     XCTAssertEqual(String(describing: challenge2.part1()), "8")

  }
   

  func testPart2() throws {
    let challenge = Day10(data: testData1)
    XCTAssertEqual(String(describing: challenge.part2()), "32000")
  }
}
