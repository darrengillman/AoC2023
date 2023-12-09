import Algorithms

struct Day07: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String
   
   struct Hand: Comparable {
      static func < (lhs: Hand, rhs: Hand) -> Bool {
         if lhs.type != rhs.type {
            return lhs.type < rhs.type
         }
         for i in 0..<5 {
            guard lhs.cards[i] != rhs.cards[i]  else { continue }
            return lhs.cards[i] < rhs.cards[i]
         }
         return true
      }

      let cards: [Card]
      let type: HandType
      let bid: Int
      let raw: String
   }
   
   enum HandType: Int, Hashable, Comparable {
      static func < (lhs: HandType, rhs: HandType) -> Bool {
         lhs.rawValue < rhs.rawValue
      }
      case high = 1
      case onePair, twoPair, threeOfAKind, fullHouse, fourOfAKind, FiveOfAKind
      
      var strength: Int {rawValue}
      
      init(_ str: String) {
         let groups = str.map{Card(from: $0)}.grouped(by: {$0}).mapValues { $0.count}
         switch (groups.values.count, groups.values.max() ) {
            case (_, 5): self = .FiveOfAKind
            case (_, 4): self = .fourOfAKind
            case (2, _): self = .fullHouse
            case (_, 3): self = .threeOfAKind
            case(3, _): self = .twoPair
            case (4, _): self = .onePair
            case (5, _): self = .high
            default: fatalError()
         }
      }
   }
   
   enum Card: Int, Comparable {
      static func < (lhs: Card, rhs: Card) -> Bool {
         lhs.rawValue < rhs.rawValue
      }
      case two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
      
      init(from str: Character){ 
         switch str {
            case "2": self = .two
            case "3": self = .three
            case "4": self = .four
            case "5": self = .five
            case "6": self = .six
            case "7": self = .seven
            case "8": self = .eight
            case "9": self = .nine
            case "T": self = .ten
            case "J": self = .jack
            case "Q": self = .queen
            case "K": self = .king
            case "A": self = .ace
            default: fatalError()
         }
      }
   }

  // Splits input data into its component parts and convert from string.
   var entities: [Hand] {
      data.trimmingCharacters(in: .whitespaces)
         .components(separatedBy: .newlines)
         .filter{!$0.isEmpty}
         .map{
            return $0.matches(of: /(?<cards>\w{5})\s+(?<bid>\d+)/ )
         }
         .map{match in
            Hand(cards: match.first!.output.cards.map{Card(from: $0)}, 
                 type: HandType(match.first!.output.cards.asString),
                 bid: Int(match.first!.output.bid)!, 
                 raw: match.first!.output.cards.asString
            )
         }
      }


  // Replace this with your solution for the first part of the day's challenge.
   
  func part1() -> Any {
     entities.sorted()
        .enumerated()
        .map{ (($0.offset)+1) * $0.element.bid }
        .reduce(0,+)
  }

  // Replace this with your solution for the second part of the day's challenge.
//  func part2() -> Any {
//    // Sum the maximum entries in each set of data
//    entities.map { $0.max() ?? 0 }.reduce(0, +)
//  }
}
