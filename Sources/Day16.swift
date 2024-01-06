import Algorithms

struct Day16: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
   var data: String
   let day = 16
   
   enum Cell: String, CustomStringConvertible {
      case space = ".", forward = "/", backward = #"\"#, horizontal = "-", vertical = "|"
      
      var description: String {self.rawValue}
      
      func exits(moving: Grid<Self>.Heading) -> [Grid<Self>.Heading] {
         switch (self, moving) {
            case (.forward, .right): return [.up]
            case (.forward, .left): return [.down]
            case (.forward, .up): return [.right]
            case (.forward, .down): return [.left]
               
            case (.backward, .right): return [.down]
            case (.backward, .left): return [.up]
            case (.backward, .up): return [.left]
            case (.backward, .down): return [.right]

            case (.horizontal, .up): return [.right, .left]
            case (.horizontal, .down): return [.right, .left]
            case (.horizontal, _): return [moving]
     

            case (.vertical, .right): return [.up, .down]
            case (.vertical, .left): return [.up, .down]
            case (.vertical, _): return [moving]
               
            case(.space, _): return [moving]
         }
      }
   }
   
   struct Location: Equatable, Hashable {
      let point: Point
      let heading: Grid<Cell>.Heading
      
      init?(_ p: Point?, _ h: Grid<Cell>.Heading) {
         guard let p else {return nil}
         heading = h
         point = p
      }
   }
   
  // Splits input data into its component parts and convert from string.
   var entities: [[Cell]] {
     data.components(separatedBy: .newlines)
        .filter{!$0.isEmpty}
        .map{$0.trimmingCharacters(in: .whitespaces)}
        .map{line in
           line.map{Cell(rawValue: $0.asString)!}
        }
  }
   
   func traceRays(from location: Location, in grid: Grid<Cell>) -> Int {
      var stack: [Location] = []
      stack.append(location)
      var visited: Set<Location> = []
      
      while !stack.isEmpty {
         let location = stack.popLast()!
         guard grid.jump(to: location.point , heading: location.heading) else {fatalError()}
         let cell = grid.value
         if visited.contains(location) {
            continue
         } else {
            visited.insert(location)
         }
         stack += cell.exits(moving: location.heading).compactMap{ Location(grid.point(looking: $0), $0) }
      }
      return visited.reduce(into: Set<Point>()) {$0.insert($1.point)}.count
   } 
   

  // Replace this with your solution for the first part of the day's challenge.
   func part1() -> Any {     
      let grid = Grid(from: entities, direction: .right) 
      return traceRays(from: Location(Point(0,0), .right)!, in: grid)
   }
     


  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
     let grid = Grid(from: entities, direction: .right) 
     assert(grid.xMax == grid.yMax)
     
     return (0...grid.xMax)
        .flatMap{[
         Location(Point(0,$0), .right)!,
         Location(Point(grid.xMax,$0), .left)!,
         Location(Point($0, 0), .down)!,
         Location(Point($0, grid.yMax), .up)!
        ]}
        .map{ traceRays(from: $0, in: grid) }
        .max()!

  }
}
