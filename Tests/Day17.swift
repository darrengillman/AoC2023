import XCTest

@testable import AdventOfCode

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day17Tests: XCTestCase {
  // Smoke test data provided in the challenge question
   
   let simpleTestData = """
      14999
      23111
      99991     
      """
   
   let testData = """
   2413432311323
   3215453535623
   3255245654254
   3446585845452
   4546657867536
   1438598798454
   4457876987766
   3637877979653
   4654967986887
   4564679986453
   1224686865563
   2546548887735
   4322674655533
   """
   
   func testMoves() {
      let ns = [
         Day17.Move(direction: .s, steps: 1),
         Day17.Move(direction: .s, steps: 2),
         Day17.Move(direction: .s, steps: 3),
         Day17.Move(direction: .n, steps: 1),
         Day17.Move(direction: .n, steps: 2),
         Day17.Move(direction: .n, steps: 3)
         ]
      
      let ew = [
         Day17.Move(direction: .e, steps: 1),
         Day17.Move(direction: .e, steps: 2),
         Day17.Move(direction: .e, steps: 3),
         Day17.Move(direction: .w, steps: 1),
         Day17.Move(direction: .w, steps: 2),
         Day17.Move(direction: .w, steps: 3),
      ]
      
      XCTAssertEqual(Set(Day17.Direction.e.moves(min: 1, max: 3)), Set(ns))
      XCTAssertEqual(Set(Day17.Direction.w.moves(min: 1, max: 3)), Set(ns))
      XCTAssertEqual(Set(Day17.Direction.n.moves(min: 1, max: 3)), Set(ew))
      XCTAssertEqual(Set(Day17.Direction.s.moves(min: 1, max: 3)), Set(ew))


   }
         
   func testStepsToOtherPoint() {
      let start = Day17.Node(point: .init(5,5), travelling: .e)
      XCTAssertEqual(
         start.steps(to: .init(point: .init(7, 5), travelling: .e)),
         [Point(6,5), Point(7,5)]
      )
      
      XCTAssertEqual(
         start.steps(to: .init(point: .init(5, 2), travelling: .n)),
         [Point(5,4), Point(5,3), Point(5,2)]
      )
      
      XCTAssertEqual(
         start.steps(to: .init(point: .init(5, 8), travelling: .s)),
         [Point(5,6), Point(5,7), Point(5,8)]
      )
      
      XCTAssertEqual(
         start.steps(to: .init(point: .init(4, 5), travelling: .w)),
         [Point(4,5)]
      )
      
      XCTAssertEqual(
         start.steps(to: .init(point: .init(5, 5), travelling: .w)),
         []
      )
   }

  func testPart1() throws {
    let challenge = Day17(data: testData)
    XCTAssertEqual(String(describing: challenge.part1()), "102")
  }

   func testSimpleTPart1() throws {
      let challenge = Day17(data: simpleTestData)
      XCTAssertEqual(String(describing: challenge.part1()), "11")
   }

   
  func testPart2() throws {
    let challenge = Day17(data: testData)
    XCTAssertEqual(String(describing: challenge.part2()), "94")
  }
}
