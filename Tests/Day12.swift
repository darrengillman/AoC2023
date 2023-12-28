import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day12Tests: XCTestCase {
  let testData = """
   ???.### 1,1,3
   .??..??...?##. 1,1,3
   ?#?#?#?#?#?#?#? 1,3,1,6
   ????.#...#... 4,1,1
   ????.######..#####. 1,6,5
   ?###???????? 3,2,1
   """
   
   let allPassData = """
#.#.### 1,1,3
.#...#....###. 1,1,3
.#.###.#.###### 1,3,1,6
####.#...#... 4,1,1
#....######..#####. 1,6,5
.###.##....# 3,2,1
"""
   
   func testAllPass() throws {
      let challenge = Day12(data: allPassData)
      XCTAssertEqual(String(describing: challenge.part1()), "6")
   }
   
  func testPart1() throws {
    let challenge = Day12(data: testData)
    XCTAssertEqual(String(describing: challenge.part1()), "21")
  }
   
   
   func testUnfolding() {
      XCTAssertEqual(Day12.Row(".# 1").unfolded, Day12.Row(".#?.#?.#?.#?.# 1,1,1,1,1"))
      XCTAssertEqual(Day12.Row("???.### 1,1,3").unfolded, Day12.Row("???.###????.###????.###????.###????.### 1,1,3,1,1,3,1,1,3,1,1,3,1,1,3"))

   }
   
   func testLine(){
      let line = "???.###????.###????.###????.###????.### 1,1,3,1,1,3,1,1,3,1,1,3,1,1,3"
   let challenge = Day12(data: line)
   XCTAssertEqual(String(describing: challenge.part1()), "1")
}
   

  func testPart2() throws {
    let challenge = Day12(data: testData)
    XCTAssertEqual(String(describing: challenge.part2()), "525152")
  }
}
