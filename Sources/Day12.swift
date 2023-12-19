import Algorithms

struct Day12: AdventDay {
   init(data: String) {
      self.data = data
      self.cache = Cache()
   }
   
   struct RowOfSprings {
      let springs: String
      let mask: [Int]
      
      var isValid: Bool {
         let groups = springs.matches(of: /#+/).map{$0.output.count}
         return groups == mask
      }
   }
   
   
   func expandOnlyUnknowns(str: String) -> [String] {
      guard str.contains("?") else {return [str]}
      let cached = cache.value(for: str)
      guard cached == nil else {return cached!}
      let resolved = expandOnlyUnknowns(str: str.dropFirst().asString).flatMap{["." + $0, "#" + $0]}
      cache.add(str, resolved)
      return resolved
   }
   
   
   func expandRow(_ str: String) -> [String] {
      guard str.contains("?") else {return [str]}
      let maybes =  str.firstMatch(of: /\?+/)!.range
      let expansions = expandOnlyUnknowns(str: str[maybes].asString)
      let results = expansions.map{str[..<maybes.lowerBound].asString + $0 + str[maybes.upperBound...].asString}
      
      return results.flatMap{expandRow($0)}
   }
   
   func expand(rowOfSprings: RowOfSprings) -> [RowOfSprings] {
      expandRow(rowOfSprings.springs).map{RowOfSprings(springs: $0, mask: rowOfSprings.mask)
      }
   }
   
   
   
  
   
   
  // Save your data in a corresponding text file in the `Data` directory.
   var data: String
   var cache: Cache

  // Splits input data into its component parts and convert from string.
  var entities: [RowOfSprings] {
     data.components(separatedBy: .newlines) 
        .map{$0.trimmingCharacters(in: .whitespaces)}
        .filter{!$0.isEmpty}
        .map{line in
           guard let split = line.firstIndex(of: " ") else {fatalError()}
           return RowOfSprings(springs: line[..<split].asString, 
                               mask: line.matches(of: /\d+/).map{Int($0.output)!})
        }
    }
   
   
   class Cache {
      
      init() {
         length = nil
      }
      private var cache = [String: [String]]()
      let length: Int?
      
      func add(_ str: String, _ arr: [String]) {
         cache[str] = arr
      }
      
      func value(for key: String) -> [String]? {
         cache[key]
      }
   }

   func expand(_ row: RowOfSprings) -> [RowOfSprings] {
      guard row.springs.contains("?") else {return [row]}
//      let cachedSprings = cache.value(for: row.springs)
//      guard cachedSprings == nil else {
//         return cachedSprings!.map{RowOfSprings(springs: $0, mask: row.mask) }
//      }
      let s1 = RowOfSprings(springs: row.springs.replacingFirstOccurrence(of: "?", with: "."), mask: row.mask)
      let s2 = RowOfSprings(springs: row.springs.replacingFirstOccurrence(of: "?", with: "#"), mask: row.mask)      
      let x1 = expand(s1)
      let x2 = expand(s2)
//      cache.add(s1.springs, x1.map{$0.springs})
//      cache.add(s2.springs, x2.map{$0.springs})
      return x1 + x2
   }
   
   
  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
     entities
        .map{ 
           expand(rowOfSprings: $0)
              .filter(\.isValid)
        }
        .reduce(0) {$0 + $1.count
     }
  }

  // Replace this with your solution for the second part of the day's challenge.
//  func part2() -> Any {
//    // Sum the maximum entries in each set of data
//    entities.map { $0.max() ?? 0 }.reduce(0, +)
//  }
}
