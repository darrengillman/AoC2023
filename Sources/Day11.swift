import Algorithms

struct Day11: AdventDay {
      // Save your data in a corresponding text file in the `Data` directory.
   var data: String
   
   struct StarMap {
      let planets: Set<Point>
      let columns: Int
      let rows: Int
      
      func calc(expansion: Int) -> Int {
         let planets = self.expanded(by: expansion)
         return planets
            .combinations(ofCount: 2)
            .map{abs($0.first!.x - $0.last!.x) + abs ($0.first!.y - $0.last!.y)}
            .reduce(0,+)
      }
      
      func expanded(by num: Int ) -> Set<Point> {
         var planets = planets
         let emptyRows = (0..<rows)
            .compactMap{rowToCheck in 
               planets.filter{$0.y == rowToCheck}.isEmpty ? rowToCheck : nil } 
            .reversed()
         
         let emptyColumns = (0..<columns)
            .compactMap{colToCheck in 
               planets.filter{$0.x == colToCheck}.isEmpty ? colToCheck : nil }
            .reversed()
         
         for row in emptyRows {
            planets = Set(planets.map{ $0.y > row ? Point($0.x, $0.y+num) : $0})
         }
         
         for column in emptyColumns {
            planets = Set(planets.map{ $0.x > column ? Point($0.x + num, $0.y) : $0})
         }       
         return planets
      }
   }
   
      // Splits input data into its component parts and convert from string.
   var entities: StarMap {
      
      let table = data
         .components(separatedBy: .newlines)
         .map{$0.trimmingCharacters(in: .whitespaces)}
         .filter{!$0.isEmpty}
         .map{$0.map{$0}}
      
         //      table.print()
         //      print()
      
      let columns = table[0].count
      let rows = table.count
      
         //      for i in stride(from: rows-1, through: 0, by: -1) {
         //         if !table[i].contains("#") {
         //            table.insert(Array(repeating: ".", count: table[0].count), at: i+1)
         //         }
         //      }
         //      
         //      for i in stride(from: columns-1, through: 0, by: -1) {
         //         if !table.map({$0[i]}).contains("#") {
         //            for j in 0..<table.count {
         //               table[j].insert(".", at: i+1)
         //            }
         //         }
         //      }
         //      
         //      table.print()
      
      var planets: Set<Point> = []
      for y in 0..<table.count {
         for x in 0..<table[0].count {
            if table[y][x] == "#" { 
               planets.insert(Point(x,y))
            }
         }
      }
      
      return StarMap(planets: planets, columns: columns, rows: rows)
   }
   
   
   
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() -> Any {
      entities.calc(expansion: 1)
   }
   
   func part2() -> Any {
      entities.calc(expansion: 1000000-1)
   }
}
