import Algorithms

extension Array where Element == Day07.Card {
   static func > (lhs: Self, rhs: Self) -> Bool{
      for i in 0..<Swift.min(lhs.count, rhs.count) {
         if lhs[i] == rhs[i] {
            continue
         }
         return lhs[i] > rhs[i]
      }
      return true //are equal
   }
   
   static func < (lhs: Self, rhs: Self) -> Bool {
      !(lhs > rhs)
   }
}

struct Day07: AdventDay {
  var data: String
   
   struct Hand: Comparable, CustomStringConvertible {
      var description: String {"\(type): \(cards) -- (\(cardsShowingJokers ?? []))" }
      
      static func < (lhs: Hand, rhs: Hand) -> Bool {
         if lhs.type != rhs.type {
            return lhs.type < rhs.type
         }
         return lhs.cardsShowingJokers ?? lhs.cards < rhs.cardsShowingJokers ?? rhs.cards
      }

      let cards: [Card]
      let cardsShowingJokers: [Card]?
      let type: HandType
      let bid: Int
      
      var playingJokers: Self {
         let options: [Card] = [.two, .three, .four, .five, .six, .seven, .eight, .nine, .ten, .queen, .king, .ace]
         
         let replaced = options.map{ option in
            cards.map{card in
               card == .jack ? option : card }
         }
         
         let scored = replaced.map{(jokeredCards: $0, type: HandType(cards: $0))}
         
         let sorted = scored.sorted{
            guard $0.type == $1.type else {return $0.type > $1.type}
            return $0.jokeredCards > $1.jokeredCards
         }
         
         let first = sorted.first!
         
         return .init(cards: first.jokeredCards, cardsShowingJokers: cards.map{$0 == .jack ? .joker : $0}, type: first.type, bid: bid)
      }
      
   }
   
   enum HandType: Int, Hashable, Comparable, CustomStringConvertible {
      var description: String {
         switch self {
            case .high: "High"
            case .onePair: "1 Pair"
            case .twoPair: "2 Pair"
            case .FiveOfAKind: "Five of"
            case .fourOfAKind: "Four of"
            case .fullHouse: "Full"
            case .threeOfAKind: "Three of"
         }
      }
      
      static func < (lhs: HandType, rhs: HandType) -> Bool {
         lhs.rawValue < rhs.rawValue
      }
      case high = 1, onePair, twoPair, threeOfAKind, fullHouse, fourOfAKind, FiveOfAKind
      
      var strength: Int {rawValue}
            
      init(cards: [Card]) {
         let groups = cards.grouped(by: {$0}).mapValues { $0.count}
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
   
   enum Card: Int, Comparable, CaseIterable, CustomStringConvertible {
      static func < (lhs: Card, rhs: Card) -> Bool {
         lhs.rawValue < rhs.rawValue
      }
      case joker = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king, ace
      
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
      
      var description: String {
         switch self {
            case .joker: "🃏"
            case .two: "2"
            case .three: "3"
            case .four: "4"
            case .five: "5"
            case .six: "6"
            case .seven: "7"
            case .eight: "8"
            case .nine: "9"
            case .ten: "T"
            case .jack: "J"
            case .queen: "Q"
            case .king: "K"
            case .ace: "A"
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
            let cards = match.first!.output.cards.map{Card(from: $0)}
            return Hand(cards: cards , cardsShowingJokers: nil, 
                        type: HandType(cards: cards),
                        bid: Int(match.first!.output.bid)!
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
  func part2() -> Any {
     entities
        .map{
           guard $0.cards.contains(.jack) else {return $0}
           return $0.playingJokers
        }
        .sorted()
        .enumerated()
        .map{ (($0.offset)+1) * $0.element.bid }
        .reduce(0,+)
  }
}
