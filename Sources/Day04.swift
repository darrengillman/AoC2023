import Algorithms
import Foundation

typealias Ticket = Int

struct Game {
   let id: Int
   let winners: Set<Int>
   let tickets: Set<Ticket>
   var wins: Set<Ticket> { winners.intersection(tickets)} 
}

struct Day04: AdventDay {
  var data: String

  var entities: [Game] {
     data.components(separatedBy: .newlines).filter{!$0.isEmpty}
        .map { line in
           line.components(separatedBy: .decimalDigits.union(.whitespaces).inverted)
              .filter{!$0.isEmpty}  //3 blocks per line
              .map{$0.replacingOccurrences(of: "  ", with: " ").trimmingCharacters(in: .whitespaces)}
              .map{ block in
                 block.components(separatedBy: .whitespaces).map{Int($0)!}
              }
        }
        .map{
           Game(id: $0[0][0], winners: Set($0[1]), tickets: Set($0[2]))
        }
  }

  func part1() -> Any {
     entities
        .map{$0.winners.intersection($0.tickets)}
        .map{$0.count}
        .filter{$0 > 0}
        .reduce(0){$0 + pow(2, $1-1)}

  }

   func part2() -> Any {
      var games = entities.reduce(into: [Int: (wins: Int, quantity: Int)]() ){ $0[$1.id] = ($1.wins.count, 1)}
      
      for key in 1...games.count {
         let current = games[key]!
         for offset in 0..<current.wins {
            games[key+offset+1]!.quantity += current.quantity
         }
      }
      return games.map(\.value.quantity).reduce(0, +)
   }
}
