import Algorithms

struct Day06: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [(Int, Int)] {
     let d = data.components(separatedBy: .newlines)
        .map{$0.matches(of: /(\d+)/)}
        .map{ row in 
           row.map{Int($0.output.1)!}
        }
     var data: [(duration: Int, record: Int)] = []
     for i in 0..<d[0].count {
        data.append((d[0][i], d[1][i]))
     }
     return data
  }


   func distances(for duration: Int) -> [Int] {
      (1..<duration).map { press in 
         press * (duration-press)
      }
   }
   
   func part1() -> Any {
      entities.map { race in
         distances(for: race.0).filter{$0 > race.1}.count
      }
      .reduce(1,*)
   }
   
  func part2() -> Any {
     let races = entities.reduce( [("", "")]) {
        [( $0.first!.0 + String($1.0)  ,  $0.first!.1 + String($1.1) )]
     }
     .map{( Int($0.0)!, Int($0.1)! )}
     
     let winners = races.map { race in
        distances(for: race.0).filter{$0 > race.1}.count
     }
     .reduce(1,*)
     
     return winners
  }
}
