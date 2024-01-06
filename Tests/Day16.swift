import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day16Tests: XCTestCase {
  // Smoke test data provided in the challenge question
  let testData = #"""
      .|...\....
      |.-.\.....
      .....|-...
      ........|.
      ..........
      .........\
      ..../.\\..
      .-.-/..|..
      .|....-|.\
      ..//.|....
      """#
   let edge1 = #"""
      \./..
      .....
      .....
      .....
      .....
      """#

  func testPart1() throws {
    let challenge = Day16(data: testData)
    XCTAssertEqual(String(describing: challenge.part1()), "46")
  }
   
   func testEdge1() {
      let challenge = Day16(data: edge1)
      let ans = challenge.part1() as! Int
      XCTAssertGreaterThan(ans, 3)

   }
   
   func testImport() {
      let challenge = Day16(data: testData)
      XCTAssertEqual(testData, Grid(from:challenge.entities).image)
   }
   
   func testRedirection() {
      let challenge = Day16(data: testData)
      let forward = Day16.Cell.forward
      let back = Day16.Cell.backward
      let vert = Day16.Cell.vertical
      let horizontal = Day16.Cell.horizontal
      let space = Day16.Cell.space
      
      XCTAssertEqual(space.exits(moving: .right), [.right])
      XCTAssertEqual(space.exits(moving: .left), [.left])
      XCTAssertEqual(space.exits(moving: .up), [.up])
      XCTAssertEqual(space.exits(moving: .down), [.down])
      
      XCTAssertEqual(forward.exits(moving: .right), [.up])
      XCTAssertEqual(forward.exits(moving: .up), [.right])
      XCTAssertEqual(forward.exits(moving: .down), [.left])
      XCTAssertEqual(forward.exits(moving: .left), [.down])

      XCTAssertEqual(back.exits(moving: .right), [.down])
      XCTAssertEqual(back.exits(moving: .up), [.left])
      XCTAssertEqual(back.exits(moving: .down), [.right])
      XCTAssertEqual(back.exits(moving: .left), [.up])

      XCTAssertEqual(Set(horizontal.exits(moving: .right)), Set([.right]))
      XCTAssertEqual(Set(horizontal.exits(moving: .up)), Set([.left, .right]))
      XCTAssertEqual(Set(horizontal.exits(moving: .down)), Set([.left, .right]))
      XCTAssertEqual(Set(horizontal.exits(moving: .left)), Set([.left]))

      XCTAssertEqual(Set(vert.exits(moving: .right)), Set([.up, .down]))
      XCTAssertEqual(Set(vert.exits(moving: .up)), Set([.up]))
      XCTAssertEqual(Set(vert.exits(moving: .down)), Set([.down]))
      XCTAssertEqual(Set(vert.exits(moving: .left)), Set([.up, .down]))
   }

  func testPart2() throws {
    let challenge = Day16(data: testData)
    XCTAssertEqual(String(describing: challenge.part2()), "51")
  }
}
