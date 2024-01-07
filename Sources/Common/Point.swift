//
//  File.swift
//  
//
//  Created by Darren Gillman on 15/12/2023.
//

import Foundation

struct Point: Hashable, CustomStringConvertible, Equatable, Comparable {
   static func < (lhs: Point, rhs: Point) -> Bool {
      guard lhs.y == rhs.y else {return lhs.y < rhs.y}
      return lhs.x < rhs.x
   }
   
   let x: Int
   let y: Int
   
   init(_ x: Int, _ y: Int) {
      self.x = x
      self.y = y
   }
   
   
   var description: String {"(\(x), \(y))"}
   
   func point(heading direction: Direction) -> Point {
      switch direction {
         case .N: Point(x, y-1)
         case .S: Point(x, y+1)
         case .E: Point(x+1, y)
         case .W: Point(x-1, y)
      }
   }
}
