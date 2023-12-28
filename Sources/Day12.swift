import Algorithms

extension StringProtocol {
   func dropFirstAnd(_ n: Int = 1, leading drop: Character = ".") -> String {
      dropFirst(n).drop(while: {$0 == drop}).asString
   }
}

extension Sequence {
   func asArray() -> Array<Element> {
      Array(self)
   }
}


struct Day12: AdventDay {
   init(data: String) {
      self.data = data
      self.cache = Cache()
   }
   
   struct Row: Hashable, CustomStringConvertible {
      var description: String {"\(str) \(groups)"}
      
      internal init(str: String, groups: [Int]) {
         self.str = str
         self.groups = groups
      }
      
      let str: String
      let groups: [Int]
      
      var unfolded: Row {Row(str: String(repeating: str+"?", count: 4)+str, groups: (1...5).flatMap{_ in groups}) }
      
      init(_ line: String) {
         guard let split = line.firstIndex(of: " ") else {fatalError()}
         str = line[..<split].asString
         groups = line.matches(of: /\d+/).map{Int($0.output)!}
      }
   }
   
   class Cache {
      private var cache = [Row: Int]()
      
      func add(_ row: Row, value: Int) {
         guard !row.str.isEmpty && !row.groups.isEmpty else {return}
         cache[row] = value
      }
      
      func value(for row: Row) -> Int? {
        cache[row]
      }      
   }

   let data: String
   let cache: Cache
   
   var entities: [Row] {
      data.components(separatedBy: .newlines) 
         .map{$0.trimmingCharacters(in: .whitespaces)}
         .filter{!$0.isEmpty}
         .map{Row($0)}
   }
   
   func process(row: Row) -> Int {
      if let value = cache.value(for: row) {
         return value
      }    
      
      let result : Int
      if row.groups.isEmpty  { result = row.str.contains("#") ? 0 : 1 }
      else if row.str.isEmpty  { result = 0 }
      else {
         switch row.str.first! {
            case ".": 
               result = dot(row) 
            case "?": 
               result = hash(row) + dot(row)
            case "#":
               result = hash(row)
            default: fatalError()
         }
      }
      cache.add(row, value: result)
      return result
   }
   
   func dot(_ row: Row) -> Int {
      process(row: .init(str: row.str.dropFirstAnd(), groups: row.groups))
   }
   
   func hash(_ row: Row) -> Int {
      let group = row.groups.first!
      guard row.str.count >= group else {return 0}
      let prefix = row.str.prefix(group).asString
      let strLeft = row.str.dropFirst(group).asString
      guard !prefix.contains( ".") else {return 0}
      if strLeft.prefix(1) == "#" {return 0}
      if strLeft.prefix(1) == "?" { return process(row: Row(str: strLeft.dropFirstAnd(), groups: row.groups.dropFirst().asArray()))}         
      return process(row: .init(str: strLeft.dropFirstAnd(0), groups: row.groups.dropFirst().asArray()))
   }
   
   
   
   func part1() -> Any {
      entities
         .map{ 
//            let length = $0.str.count
            let n = process(row: $0)
               //           print($0, n, separator: " = ")
            return n
         }
         .reduce(0, +)
   }
   
   func part2() -> Any {
      entities
         .map{ $0.unfolded }
         .map{ 
//            let length = $0.str.count
            //cache.clear()
            let n = process(row: $0)
//                          print($0, n, separator: " = ")
            return n
         }
         .reduce(0, +)
   }
}

