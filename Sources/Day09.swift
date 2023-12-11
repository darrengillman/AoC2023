import Algorithms

extension Array where Array.Element == Int {
   var allZero: Bool {allSatisfy({$0 == 0})}
}

struct Day09: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
   
   struct Survey {
      var rows: [[Int]]
            
      func nextRow(for row: [Int]) -> [Int] {
         row.adjacentPairs().map{$0.1-$0.0}
      }
      
      
      mutating func extrapolate(backwards: Bool = false) -> Int {
         while !rows.last!.allZero {
            rows.append(nextRow(for: rows.last!))
         }
         return rows
            .reversed()
            .map{backwards ? $0.reversed() : $0}
            .reduce(0){backwards ? $1.last! - $0 : $1.last! + $0}
      }
   }

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
     data
        .components(separatedBy: .newlines)
        .map{$0.trimmingCharacters(in: .whitespaces)}
        .filter{!$0.isEmpty}
        .map{$0.components(separatedBy: .whitespaces)}
        .map{$0.map{Int($0)!}}
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
     var surveys = entities.map{Survey(rows: [$0])}

     return (0..<surveys.count).reduce(0){ total, index in
        total + surveys[index].extrapolate()
     }     


  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
     var surveys = entities.map{Survey(rows: [$0])}
     
     return (0..<surveys.count).reduce(0){ total, index in
        total + surveys[index].extrapolate(backwards: true )
     }     
  }
}
