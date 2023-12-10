import Algorithms
struct Day08: AdventDay {
      // Save your data in a corresponding text file in the `Data` directory.
   var data: String
   
   enum Turn {
      case left, right
   }
   
   struct Node {
      let id, left, right: String
   }
   
   struct Puzzle {
      let turns: [Turn]
      let nodes: [Node]
      let startNodeId = "AAA"
      let endNodeId = "ZZZ"
      
      init(_ str: String) {
         let lines = str.components(separatedBy: .newlines)
         turns = lines.first!.map{$0 == "R" ? .right : .left}
         nodes = lines[2...].map{ line in
            let matches = line.matches(of: /\w{3}/)
            return Node(id: matches[0].output.asString, left: matches[1].output.asString, right: matches[2].output.asString)
         }
      }
      
      func part1(startNode: Node? = nil, target: ((String) -> Bool)? = nil ) -> Int {
         var turnIndex = 0
         var current: Node = startNode ?? nodes.first{$0.id == startNodeId}!
         var count = 0
         let completed: (String) -> Bool = target ?? {id in id == endNodeId}
         while !completed(current.id) {
            current = nodes.first{$0.id == (turns[turnIndex] == .left ? current.left : current.right) }!
            count += 1
            turnIndex = turnIndex + 1 == turns.count ? 0 : turnIndex + 1
         }
         return count
      }
      
      func part2() -> Int {
         nodes
            .filter{$0.id.last! == "A"}
            .map{part1(startNode: $0, target: {id in id.last! == "Z"})}
            .lcm()
         
         
         
      } 
   }
   
      // Splits input data into its component parts and convert from string.
   var entities: Puzzle {
      Puzzle(data)
   }
   
      // Replace this with your solution for the first part of the day's challenge.
   func part1() -> Any {
         // Calculate the sum of the first set of input data
      entities.part1()
   }
   
      // Replace this with your solution for the second part of the day's challenge.
   func part2() -> Any {
         // Sum the maximum entries in each set of data
      entities.part2()
   }
}
