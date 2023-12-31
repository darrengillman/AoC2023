import Algorithms
import Foundation

extension Array where Element:Comparable {
   var mirrorAfterIndex: [Int] {
      var mirrors = [(index: Int, arr: [Element])]()
      for i in indices {
         let f = self[0...i]
         let b = self[(i+1)...]
         let trim = Swift.min(f.count, b.count)
         guard trim > 0 else {continue}
         let left = f.suffix(trim).reversed().asArray()
         let right = b.prefix(trim).asArray()
         
         if left == right {
            mirrors.append((i, left))
         }
      }
      return mirrors.map(\.index)
   }
}


struct Day13: AdventDay {
   
   struct Pattern{
      let raw: String
      let lines: [[Character]]
      
      init(_ s: String) {
         raw = s
         lines = s
            .components(separatedBy: .newlines)
            .filter{!$0.isEmpty}
            .map{$0.trimmingCharacters(in: .whitespaces)}
            .map{$0.map{$0}}
      }
      
      private func findMirror(in grid: [[Character]] ) -> Int {
         let mirrorAfter = grid
            .map(\.mirrorAfterIndex)
            .reduce(Set((0...100).map{$0})){$0.intersection(Set($1))}
            .first
         return mirrorAfter != nil ? mirrorAfter! + 1 : 0
      }
      
      private func flip<T>(_ a: Array<Array<T>>) -> Array<Array<T>> {
         let xR = 0..<a[0].count
         let yR = 0..<a.count
         var flipped: [[T]] = xR.map{_ in Array<T>.init()}
         
         for y in yR {
            for x in xR {
               flipped[x].append(a[y][x])
            }
         }
         return flipped
      }
      
      private func findNewMirror(in lines: [[Character]]) -> Int? {
         for x in 0..<lines[0].count {
            var y = 0
            var diffs = 0
            while y<lines.count && diffs < 2 {
               let row = lines[y]
               let f = row[0...x]
               let b = row[(x+1)...]
               let trim = Swift.min(f.count, b.count)
               guard trim > 0 else {y += 1; continue}
               let left = f.suffix(trim).reversed().asArray()
               let right = b.prefix(trim).asArray()
               diffs += zip(left, right).reduce(0){ $0 + ($1.0 != $1.1 ? 1 : 0) }
               y += 1
            }
            if diffs == 1 {
               return x
            }
         }
         return nil
      }
            
      var vMirror: Int {
         findMirror(in: lines)
      }
      
      var vSmudgedMirror: Int {
         let mirrorAfter = findNewMirror(in: lines)
         return mirrorAfter == nil ? 0 : mirrorAfter! + 1
      }
      
      var hMirror: Int {
         findMirror(in: flip(lines))
      }      
      
      var hSmudgedMirror: Int {
         let mirrorAfter = findNewMirror(in: flip(lines))
         return mirrorAfter == nil ? 0 : mirrorAfter! + 1
      }
}
   
   let day = 13
   var data: String

  var entities: [Pattern] {
    data.components(separatedBy: "\n\n").map { Pattern($0)}
  }

   func part1() -> Any {
      entities.map { pattern in
         pattern.vMirror + pattern.hMirror*100
      }
      .reduce(0,+)
   }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
     entities.map { pattern in
        pattern.vSmudgedMirror + pattern.hSmudgedMirror*100
     }
     .reduce(0,+)

  }
}
