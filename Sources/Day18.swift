import Algorithms

extension Point {
   func move(steps: Int, direction: Day18.Move) -> Point {
     return switch direction {
        case .U: Point(self.x, self.y - steps)
        case .D: Point(self.x, self.y + steps)
        case .R: Point(self.x + steps, self.y)
        case .L: Point(self.x - steps, self.y)
      }
   }
}


struct Day18: AdventDay {
  var data: String
   let day = 18

  var entities: [String] {
     data.components(separatedBy: .newlines)
        .filter{!$0.isEmpty}
        .map{$0.trimmingCharacters(in: .whitespaces)}
  }
   
   
   enum Move: String {
      case U, D, L, R
      
      var dx: Int {
         switch self {
            case .U: 0
            case .D: 0
            case .L: -1
            case .R: 1
         }
      }      
      var dy: Int {
         switch self {
            case .U: -1
            case .D: 1
            case .L: 0
            case .R: 0
         }
      }
   }
   
   func calculate(from vertices: [Point]) -> Int {     
      var sum1 = 0
      var sum2 = 0
      for i in 0..<vertices.count-1 {
         let j = i+1
         sum1 += vertices[i].x * vertices[j].y
         sum2 += vertices[i].y * vertices[j].x
      }
      return abs(sum1-sum2) / 2
   }
   
   

  func part1() -> Any {
     let regex = /^(\w) (\d+) \((.{7})\)/

     let vertices = entities.reduce(into: [Point(0,0)]) {
        let (dir, steps, _) = $1.matches(of: regex).map{(Move(rawValue: $0.output.1.asString)!, $0.output.2.asInt!, $0.output.3.asString)}.first!
        $0.append($0.last!.move(steps: steps, direction: dir))
     }
     let perimeter = entities.map{$0.matches(of: /(\d+)/)}.compactMap{$0.first?.output.1.asInt}.reduce(0,+)

     return calculate(from: vertices) + perimeter/2 + 1  //50104 too low
  }

  func part2() -> Any {
     let regex = /\(#(.{6})\)/
     
     let instructions = entities
        .map{$0.matches(of: regex)}
        .compactMap{$0.first?.output.1.asString}
        .map{ (Int($0.prefix(5), radix: 16)!, $0.suffix(1).asInt! ) }
        .map{ ($0.0, Move(rawValue: ["R", "D", "L", "U"][$0.1]) )}
     
     let vertices = instructions.reduce(into: [Point(0,0)]){$0.append($0.last!.move(steps: $1.0, direction: $1.1!))}
     let perimeter = instructions.reduce(0){$0 + $1.0}
     
     return calculate(from: vertices) + perimeter/2 + 1
  }
}
