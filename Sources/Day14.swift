import Algorithms

struct Day14: AdventDay {
   enum Square: Hashable, CustomStringConvertible {
      var description: String {
         switch self {
            case .round: "◎"
            case .cube: "◼︎"
            case .space: "."
         }
      }
      
      case round, cube, space
      
      init(_ char: Character) {
         switch char {
            case "O": self = .round
            case "#": self = .cube
            case ".": self = .space
            default: fatalError()
         }
      }
   }
   
   enum Direction {
      case N, S, E, W
      
      func slide( _ x: Int, _ y: Int) -> (Int, Int) {
         switch self {
            case .N: (x, y-1) 
            case .S: (x, y+1)
            case .E: (x+1, y)
            case .W: (x-1, y)
         }
      }
   }
   
   class Table: Hashable {
      static func == (lhs: Day14.Table, rhs: Day14.Table) -> Bool {
         lhs.squares == rhs.squares
      }
      
      func hash(into hasher: inout Hasher) {
         squares.forEach {
            hasher.combine($0)
         }
      }
      
      var squares: [[Square]]
      

      
      var load: Int {
         var sum = 0
         for row in 0..<squares.count {
            let lineSum = squares[row].filter{$0 == .round}.count * (squares.count - row)
            sum += lineSum
         }
         return sum
      }
      
      init(squares: [[Square]]) {
         self.squares = squares
      }
      
      private func moveIsValid( from point: (x: Int, y: Int), heading direction: Direction) -> Bool {
            switch direction {
               case .N: point.y > 0
               case .S: (squares.count - point.y) > 1 
               case .E: (squares[point.y].count - point.x) > 1 
               case .W: point.x > 0
            }
         }
      
      private func moveIfFree(_ x: Int, _ y: Int, direction: Direction) {
         guard moveIsValid(from: (x,y), heading: direction) else {return} 
         guard squares[y][x] == .round else {return}
         let (toX, toY) = direction.slide(x, y)
         guard squares[toY][toX] == .space else {return }
         
         squares[toY][toX] = squares[y][x]
         squares[y][x] = .space
         moveIfFree(toX, toY, direction: direction)
      }
      
      var output: String {
         squares.map {
           $0.map(\.description).joined()
         }.joined(separator: "\n")
      }
      
      private func tiltNorth() {
         for y in 0..<squares.count {
            for x in 0..<squares[y].count {
               moveIfFree(x, y, direction: .N)
            }
         }
      }
      
      private func tiltSouth() {
         for y in stride(from: squares.count-1, through: 0, by: -1) {
            for x in 0..<squares[y].count {
               moveIfFree(x, y, direction: .S)
            }
         }
      }
      
      
      private func tiltWest() {
         for x in 0..<squares[1].count {
            for y in 0..<squares.count {
               moveIfFree(x, y, direction: .W)
            }
         }
      }
      
      private func tiltEast() {
         for x in stride(from: squares[1].count-1, through: 0, by: -1) {
            for y in 0..<squares.count {
               moveIfFree(x, y, direction: .E)
            }
         }
      }
      
      func tilt(direction: Direction) {   
         switch direction {
            case .N: tiltNorth()
            case.S: tiltSouth()
            case .E: tiltEast()
            case .W: tiltWest()
         }
      }
   }
   
   
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
   let day = 14

  // Splits input data into its component parts and convert from string.
  var entities: [[Square]] {
     data.components(separatedBy: .newlines)
        .filter{!$0.isEmpty}
        .map{$0.trimmingCharacters(in: .whitespaces)}
        .map{$0.map{Square($0)}
    }
  }

  func part1() -> Any {
     let table = Table(squares: entities)
     table.tilt(direction: .N)
     return table.load
  }

  func part2() -> Any {
     var cache = [[[Square]]: Int]()
     var loads = [Int]()
     let table = Table(squares: entities)

     for i in 0..<1000 {
        table.tilt(direction: .N)
        table.tilt(direction: .W)
        table.tilt(direction: .S)
        table.tilt(direction: .E)
        
        if let cached = cache[table.squares] {
           let cycleLength = i - cached 
           let offset = cached - 1
           let mod = (1000000000 - offset) % cycleLength
           return loads[offset+mod]
        } else { 
           cache[table.squares] = i
           loads.append( table.load)
        }
     }
     fatalError()     
  }
}
