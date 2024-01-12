import Algorithms

struct Day17: AdventDay {
   init(data: String) {
      self.data = data
   }
   
   
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
   
  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
     data.components(separatedBy: .newlines)
        .filter{!$0.isEmpty}
        .map{$0.trimmingCharacters(in: .whitespaces)}
        .map{$0.map{$0.asString.asInt!}
    }
  }
   
   struct Node: Hashable {
      let point: Point
      let travelling: Direction
      
      func nextNodes(xRange: ClosedRange<Int>, yRange: ClosedRange<Int>, min: Int, max: Int) -> [Node] {
         (point == .init(0,0) 
          ? Direction.e.moves(min: min, max: max) + Direction.s.moves(min: min, max: max) 
          : travelling.moves(min: min, max: max)
         )
         .map{Node(point: Point(point.x + $0.dx, point.y + $0.dy), travelling: $0.direction)}
         .filter{xRange ~= $0.point.x && yRange ~= $0.point.y}
      }
      
      func steps(to other: Node) -> [Point] {
         guard point != other.point else {return []}
         guard (other.point.x == point.x || other.point.y == point.y) else {
            fatalError("Unable to reach \(point) from \(other.point) in one step")
         }
         let steps = max(abs(point.x-other.point.x), abs(point.y-other.point.y))
         return switch(other.travelling) {
            case .e: (1...steps).map{Point(point.x + $0, point.y)}
            case .w: (1...steps).map{Point(point.x - $0, point.y)}
            case .s: (1...steps).map{Point(point.x, point.y + $0)}
            case .n: (1...steps).map{Point(point.x, point.y - $0)}
         }
      }
   }
   
   struct Move: Equatable, Hashable {
      let direction: Direction
      let steps: Int
      var dy: Int {
         switch direction {
            case .n: -steps
            case .s: steps
            case .e: 0
            case .w: 0
         }
      }
      var dx: Int {
         switch direction {
            case .n: 0
            case .s: 0
            case .e: steps
            case .w: -steps
         }
      }
   }
   
   
   enum Direction: Hashable {
      case n, s, e, w
      private var next: [Direction] {
         switch self {
            case .n, .s: [.e, .w]
            case .e, .w: [.n, .s]
         }
      }
      
      func moves(min: Int, max: Int) -> [Move] {
         (min...max).flatMap{ steps in
            next.map{ dir in
               Move(direction: dir, steps: steps)
            }
         }
      }
   }
   
   typealias Cost = Int
   
   
   func calculate(minStraight: Int, maxStraight: Int) -> Int {
     let grid = entities
     let xRange = {0...grid[1].count - 1}()
     let yRange = {0...grid.count - 1}()
     var visited: [Node: Cost] = [:]
     

     var queue: [Cost: [Node]] = [0: [Node(point: .init(0,0), travelling: .e)]]
     
     let exit = Point(xRange.upperBound, yRange.upperBound)
     
     var next: (cost: Cost, node: Node)? {
        guard let key = queue.keys.min(), let next = queue[key]!.popLast() else { return nil }
        if queue[key]!.isEmpty {queue[key] = nil}
        return (key, next)
     }
     
     while let next {
        guard visited[next.node] == nil else {continue}
        guard next.node.point != exit else {return next.cost}
        visited[next.node] = next.cost
        let validNodes = next.node.nextNodes(xRange: xRange, yRange: yRange, min: minStraight, max: maxStraight)
           
        validNodes.forEach{ validNode in
           let cost = next.cost + next.node.steps(to: validNode).reduce(0){$0 + grid[$1.y][$1.x]}
           if queue[cost] == nil || !queue[cost]!.contains(validNode) {
              queue[cost, default: []].append(validNode)
           }
        }
     }
     
     fatalError("no exit found")
  }
   
   func part1() -> Any {
      calculate(minStraight: 1, maxStraight: 3)
   }

  func part2() -> Any {
     calculate(minStraight: 4, maxStraight: 10)

  }
}

//
//let grid = Grid(from: entities)
//return grid.lcr(from: .init(0,0), to: .init(grid.xMax, grid.yMax), maxStraight: 3)   //988 too ghihg
