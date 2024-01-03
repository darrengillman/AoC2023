import Algorithms

extension BinaryInteger {
   var asInt: Int {Int(self)}
}

extension String {
   var hashed: Int {
      reduce(0){ ( ( ($0 + $1.asciiValue!.asInt) * 17 ) % 256) }
   }
}

struct Day15: AdventDay {
      // Save your data in a corresponding text file in the `Data` directory.
   var data: String
   let day = 15
   
   struct Box: CustomStringConvertible {
      struct Lens: Equatable, CustomStringConvertible {
         static func == (lhs: Lens, rhs: Lens) -> Bool {
            lhs.id == rhs.id
         }
         
         let id: String
         let fLength: Int
         var description: String { "[\(id) \(fLength)]" }
      }
      
      let id: Int
      var lenses: [Lens?]
      
      var description: String {"Box \(id): \(lenses.compactMap{$0}.map(\.description).joined(separator: " ")) : fp: \(focalPower)"}
      
      var focalPower: Int {
         lenses.compacted().enumerated().reduce(0){$0 + (id + 1) * ($1.offset+1) * ($1.element.fLength)}
      }
      
      var isEmpty: Bool {lenses.compacted().isEmpty}
      
      func contains(_ lensID: String) -> Bool {
         lenses.contains{
            $0 != nil && $0!.id == lensID
         }
      }
      
      mutating func add(_ lens: Lens) {
         if let index = lenses.firstIndex(where: {$0 != nil && $0!.id == lens.id}) {
            lenses[index] = lens
         } else {
            lenses.append(lens)
         }
      }
      
      mutating func remove(_ lensId: String) {
         guard let index = lenses.firstIndex(where: {$0 != nil && $0!.id == lensId}) else { return }
         lenses[index] = nil
         lenses = lenses.compactMap{$0}
      }
   }

   
  // Splits input data into its component parts and convert from string.
  var entities: [String] {
     let d = data
        .trimmingCharacters(in: .newlines)
        .components(separatedBy: ",")
     return d
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
     entities.reduce(0){ $0 + $1.hashed}
  }
   

   


      // Replace this with your solution for the second part of the day's challenge.
   func part2() -> Any {
      var hashmap = [Int: Box]()
      
      for e in entities {
         let label = e.matches(of: /\w+/).first!.output.asString
         let box = label.hashed
         let op = e.firstMatch(of: /[=|-]/)!.output.first!.asString
         let flength = e.matches(of: /\d+/).first?.output.asInt
         
         switch op {
            case "-": 
               hashmap[box]?.remove(label)
            case "=": 
               hashmap[box, default: Box(id: box, lenses: [])].add(Box.Lens(id: label, fLength: flength!))
            default: fatalError()
         }         
      }
      
      let result = hashmap.filter{!$0.value.isEmpty}.reduce(0){$0 + $1.value.focalPower}   
      return result
      
   }
}
