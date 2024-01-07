import Algorithms

struct Day17: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
   
   typealias Cell = Int

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
     data.components(separatedBy: .newlines)
        .map{$0.map{$0.asString.asInt!}
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
     let grid = Grid(from: entities)
     return grid.lcr(from: .init(0,0), to: .init(grid.xMax, grid.yMax))
    // Calculate the sum of the first set of input data
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    entities.map { $0.max() ?? 0 }.reduce(0, +)
  }
}
