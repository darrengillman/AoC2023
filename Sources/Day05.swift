import Algorithms

extension Int {
   func applying(transforms: [Transform]) -> Int {
      guard let offset = transforms
         .first(where: {$0.source.contains(self)})?.offset else { return self}
      return self+offset
   }
}

struct Transform {
   let mapping: Mapping
   let source: ClosedRange<Int>
   let offset: Int
   
   func process(ranges: [ClosedRange<Int>]) -> (transformed: [ClosedRange<Int>], remaining: [ClosedRange<Int>]) {
      ranges.reduce(into: (transformed: [ClosedRange<Int>](), remaining: [ClosedRange<Int>]() ) ){ tuple, range in
         let result = range.removing(source)
         if let removed = result.removed {
            tuple.transformed.append(removed.lowerBound+offset...removed.upperBound+offset)
         }
         tuple.remaining += result.remaining
      }
   }
}
      
      

enum Mapping: String {
   case seedToSoil = "seed-to-soil map:"
   case soilToFert = "soil-to-fertilizer map:"
   case fertToWater = "fertilizer-to-water map:"
   case waterToLight = "water-to-light map:"
   case lightToTemp = "light-to-temperature map:"
   case tempToHumidity = "temperature-to-humidity map:"
   case humidityToLocation = "humidity-to-location map:"
}


struct Puzzle {
   let seeds: [Int]
   let transforms: [Transform]
   var rangedSeeds: [ClosedRange<Int>] {seeds.chunks(ofCount: 2).map{$0.first!...$0.first!+$0.last!-1} }
   
   func apply(transforms: [Transform], to ranges: [ClosedRange<Int>]) -> [ClosedRange<Int>] {
      var pool = ranges
      var transformed: [ClosedRange<Int>] = []
      for transform in transforms {
         let output = transform.process(ranges: pool)
         transformed += output.transformed
         pool = output.remaining
      }
      return transformed + pool
      }
   
   
   private func transforms(for mapping: Mapping) -> [Transform] {
      transforms.filter{$0.mapping == mapping}
   }
   
   init(input: String) {
      var map = Mapping.seedToSoil
      let lines = input.components(separatedBy: .newlines).filter{!$0.isEmpty}
      seeds = lines.first!.matches(of: /\d+/).map{Int($0.output)!}
      transforms = lines
         .dropFirst()
         .compactMap{ line in
            guard !line.contains(":") else { 
               map = Mapping(rawValue: line)!
               return nil
            } 
            let ints = line.components(separatedBy: .whitespaces).map{Int($0)!}
            return .init(mapping: map, source: ints[1]...ints[1]+ints[2]-1, offset: ints[0]-ints[1])
         }
   }
   
   func part1() -> Int {
      seeds
         .map{$0.applying(transforms: transforms(for: .seedToSoil))}
         .map{$0.applying(transforms: transforms(for: .soilToFert))}
         .map{$0.applying(transforms: transforms(for: .fertToWater))}
         .map{$0.applying(transforms: transforms(for: .waterToLight))}
         .map{$0.applying(transforms: transforms(for: .lightToTemp))}
         .map{$0.applying(transforms: transforms(for: .tempToHumidity))}
         .map{$0.applying(transforms: transforms(for: .humidityToLocation))}
         .min()!
   }
   
   
   
   
   mutating func part2() -> Int {
      let soil = apply(transforms: transforms(for: .seedToSoil), to: rangedSeeds)  
      let fert = apply(transforms: transforms(for: .soilToFert ), to: soil)
      let water = apply(transforms: transforms(for: .fertToWater), to: fert)
      let light = apply(transforms: transforms(for: .waterToLight), to: water)
      let temp = apply(transforms: transforms(for: .lightToTemp), to: light)
      let hum = apply(transforms: transforms(for: .tempToHumidity), to: temp)
      let loc = apply(transforms: transforms(for: .humidityToLocation), to: hum)
      return loc.min(by: {$0.lowerBound < $1.lowerBound})!.min()!
   }
}


struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: Puzzle {
     .init(input: data)
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    // Calculate the sum of the first set of input data
     let puzzle = Puzzle(input: data)
     return puzzle.part1()
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
     var puzzle = Puzzle(input: data)
     return puzzle.part2()  }
}
