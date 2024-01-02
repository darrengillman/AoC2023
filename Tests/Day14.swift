import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day14Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = """
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
"""

  func testPart1() throws {
    let challenge = Day14(data: testData)
    XCTAssertEqual(String(describing: challenge.part1()), "136")
  }

   func testNorth() {
      
      let after1 = """
      .....#....
      ....#...O#
      ...OO##...
      .OO#......
      .....OOO#.
      .O#...O#.#
      ....O#....
      ......OOOO
      #...O###..
      #..OO#....
      """
      
      let after2 = """
      .....#....
      ....#...O#
      .....##...
      ..O#......
      .....OOO#.
      .O#...O#.#
      ....O#...O
      .......OOO
      #..OO###..
      #.OOO#...O
      """
      
      let after3 = """
         .....#....
         ....#...O#
         .....##...
         ..O#......
         .....OOO#.
         .O#...O#.#
         ....O#...O
         .......OOO
         #...O###.O
         #.OOO#...O
         """
      
      let challenge = Day14(data: testData)
      let table = Day14.Table(squares: challenge.entities)
      table.tilt(direction: .N)
      table.tilt(direction: .W)
      table.tilt(direction: .S)
      table.tilt(direction: .E)
      let after1Cycle = Day14.Table(squares: Day14(data: after1).entities)
      XCTAssertEqual(table.output, after1Cycle.output)
      
      table.tilt(direction: .N)
      table.tilt(direction: .W)
      table.tilt(direction: .S)
      table.tilt(direction: .E)
      let after2Cycle = Day14.Table(squares: Day14(data: after2).entities)
      XCTAssertEqual(table.output, after2Cycle.output)
      
      table.tilt(direction: .N)
      table.tilt(direction: .W)
      table.tilt(direction: .S)
      table.tilt(direction: .E)
      let after3Cycle = Day14.Table(squares: Day14(data: after3).entities)
      XCTAssertEqual(table.output, after3Cycle.output)


   }
   
  func testPart2() throws {
    let challenge = Day14(data: testData)
    XCTAssertEqual(String(describing: challenge.part2()), "64")
  }
}
