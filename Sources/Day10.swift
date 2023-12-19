import Algorithms

enum Direction {
   case N, S, E, W
   
   var back: Self {
      switch self {
         case .N: .S
         case .S: .N
         case .E: .W
         case .W: .E
      }
   }
}

enum Tile: Character, CustomStringConvertible {
   case vertical = "|"
   case horizontal = "-" 
   case NEBend = "L"
   case NWBend = "J"
   case SEBend = "F" 
   case SWBend = "7"
   case Space = "."
   case start = "S"
   
   var description: String {"\(rawValue)"}
   
   private func validTiles(for direction: Direction) -> [Tile]{
      let valid: [Tile] =  switch (self, direction) {
         case (.vertical, .N): [.vertical, .SEBend, .SWBend]
         case (.vertical, .S): [.vertical, .NEBend, .NWBend]
         case (.horizontal, .E): [.horizontal, .SWBend, .NWBend]
         case (.horizontal, .W): [.horizontal, .NEBend, .SEBend]
         case (.NEBend, .N): [.vertical, .SEBend, .SWBend]
         case (.NEBend, .E): [.horizontal, .NWBend, .SWBend]
         case (.NWBend, .N): [.vertical, .SEBend, .SWBend]
         case (.NWBend, .W): [.horizontal, .NEBend, .SEBend]
         case (.SEBend, .S): [.vertical, .NEBend, .NWBend]
         case (.SEBend, .E): [.horizontal, .SWBend, .NWBend]
         case (.SWBend, .S): [.vertical, .NEBend, .NWBend]
         case (.SWBend, .W): [.horizontal, .NEBend, .SEBend]
         case(.start, .N): [.vertical, .SEBend, .SWBend]
         case(.start, .S): [.vertical, .NEBend, .NWBend]
         case(.start, .W): [.horizontal, .NEBend, .SEBend]
         case(.start, .E): [.horizontal, .SWBend, .NWBend]
         default: []
      }
      return valid + [.start]
   }
   
   var validDirections: Set<Direction> {
      switch self {
         case .vertical: [.N, .S]
         case .horizontal: [.E, .W]
         case .NEBend: [.N, .E]
         case .NWBend: [.N, .W]
         case .SEBend: [.S, .E]
         case .SWBend: [.S, .W]
         case .Space: []
         case .start: [.N, .S, .E, .W]
      }
   }
   
   func checkIfValidTile(_ tile: Tile, inDirection heading: Direction) -> Bool {
      validTiles(for: heading).contains(tile)
   }
} 



//struct Node: Equatable, CustomStringConvertible {
//   static func == (lhs: Node, rhs: Node) -> Bool {
//      lhs.point == rhs.point
//   }
//   
//   var description: String {"** \(tile) @ \(point)"}
//   let point: Point
//   let tile: Tile
//   var back: Point?
//}

struct Map {
   var nodes: [Point: Tile]
   let start: Point
   var xRange: ClosedRange<Int>
   var yRange: ClosedRange<Int>
   
   
   func validDirections(from point: Point) -> Set<Direction> {
      Set(
         [Direction.N, .S, .E, .W].compactMap{
            switch $0 {
               case .N: point.y > 0 ? Direction.N : nil
               case .S: point.y < yRange.upperBound ? .S : nil
               case .E: point.x < xRange.upperBound ? .E : nil
               case .W: point.x > 0 ? .W : nil
            }
         }
      )
   }
   
   func moves(from current: Point, avoiding: Point?) -> Point {
      let validDirections = validDirections(from: current).intersection(nodes[current]!.validDirections) //viable on map && viable for tile type
      let validPoints = validDirections.map{(dir: $0, point: current.point(heading: $0) )}
      let filteredValidPoints = avoiding == nil ? validPoints : validPoints.filter{$0.point != avoiding!}  //removes backtracking
      let destinations = filteredValidPoints.filter{nodes[current]!.checkIfValidTile(nodes[$0.point]!, inDirection: $0.dir)}
      return destinations.first!.point
   }
   
   
   func findLoop() -> [Point] {
      var route: [Point] = []
      var current = start
      var previous: Point?
      while current != start || route.isEmpty {
         route.append(current)
         let nextStep = moves(from: current, avoiding: previous)
         previous = current
         current = nextStep
      }
      print(route.count)
      if route.count < 20 {
         route.forEach{print($0)}
      }

      return route
   }
}

struct Day10: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
   var entities: Map {
     let input = data.components(separatedBy: .newlines)
         .map{$0.trimmingCharacters(in: .whitespaces)}
         .filter{!$0.isEmpty}
         .map{$0.map{$0}}
      let xRange = 0...input[1].count - 1
      let yRange = 0...input.count - 1
      var dict = [Point: Tile]()
      var start: Point?
      for y in yRange {
         for x in xRange {
            let tile = Tile(rawValue: input[y][x])!
            let point = Point(x,y)
            dict[point] = tile
            if tile == .start {
               start = point
            }
         }
      }
      return Map(nodes: dict, start: start!, xRange: xRange, yRange:  yRange)
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
   let map = entities
     let route = map.findLoop()
     return route.count / 2
  }  //6696, 6700 too low

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {

     //premise: just flood fill from all edge points.  Anything left  after that must be isolated
     //probabaly makes it easier to detect squashed pipes too.
     enum State {
        case unvisited, pipe, inside, outside
     }
     
     let map = entities
     var grid = Array(repeating: Array(repeating: State.unvisited, count: map.xRange.upperBound), count: map.yRange.upperBound)
     var edges = map.xRange.reduce( [(Int, Int)]() ){$0 + [($1, 0), ($1, map.yRange.upperBound)]} +  map.yRange.reduce( [(Int, Int)]() ){$0 + [(0, $1), (map.xRange.upperBound,0)]}
   
     
     func neighbours(from point: (x:Int, y:Int)) -> [(Int, Int)] {
        zip([1, 0, -1, 0],[0, 1, 0, -1] ).map{(point.x + $0.0, point.y + $0.1)}
     }
   
     
     func isValid(_ point: (x: Int, y: Int)) -> Bool {
        map.xRange ~= point.x && map.yRange ~= point.y
     }
     
     func dfs(start: (Int, Int)) {
        var outside = false
        var stack = [start]
        var path = [(x: Int, y: Int)]()
        while let point = stack.popLast() {
           let neighbours = neighbours(from: point).filter{isValid($0)}
           let routes = neighbours.filter{grid[$0.1][$0.0] == .unvisited}
           path.append(point)
           stack += routes
           if !outside {
              outside = point.0 == 0 || point.0 == map.xRange.upperBound || point.1 == 0 || point.1 == map.yRange.upperBound
           }
        }
        path.forEach { (x: Int, y: Int) in
           grid[y][x] = outside ? .outside : .inside
        }
     }
     


     map.findLoop().forEach{grid[$0.y][$0.x] = .pipe}
     var next: (x: Int, y: Int)? { !edges.isEmpty ? edges.removeFirst() : nil }

//     
//     while let edge {
//        dfs(start: edge)
//        
//     }
//     
     return 0
  }
}
