//
//  File.swift
//  
//
//  Created by Darren Gillman on 10/12/2023.
//

import Foundation

extension Array where Element == Int {
      // Euclid's algorithm for finding the greatest common divisor
   private func gcd(_ a: Int, _ b: Int) -> Int {
      let r = a % b
      if r != 0 {
         return gcd(b, r)
      } else {
         return b
      }
   }
   
   
      // Returns the least common multiple of two numbers.
   private func lcm(_ m: Int, _ n: Int) -> Int {
      return m / gcd(m, n) * n
   }
   
   
      // Returns the least common multiple of of an array of Int.
   func lcm() -> Int {
      return self.reduce(1) { lcm($0, $1) }
   }
}
