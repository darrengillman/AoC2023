   //
   //  File.swift
   //  
   //
   //  Created by Darren Gillman on 03/01/2024.
   //

import Foundation

class Grid<T: CustomStringConvertible> {
   enum Heading {
      case left, right, up, down
   }
   
   subscript(_ p: (x: Int, y: Int)) -> T? {
      grid[Point(p.x, p.y)]
   }
   
   subscript(_ p: Point) -> T? {
      grid[p]
   }
   
   private var grid: [Point: T] 
   var action: () -> Void
   private (set) var current: Point
   private (set) var heading:  Heading  
   let xMax, yMax: Int
   private let stride: Int
   
   var value: T {grid[current]!}
   
   var image: String {
      var lines = [String]()
      for y in 0...yMax {
         var line = ""
         for x in 0...xMax{
            line += grid[Point(x,y)]!.description
         }
         lines.append(line)
      }
      return lines.joined(separator: "\n")
   }
   
   init(from array2D: [[T]], start: Point = .init(0,0), direction: Heading = .left, step: Int = 1, action: @escaping () -> Void = {} ) {
      current = start
      stride = step
      heading = direction
      grid = [Point: T]()
      self.action = action
      xMax = array2D.map{$0.count}.max()!-1
      yMax = array2D.count-1
      for y in 0...yMax{
         for x in 0...xMax {
            grid[Point(x,y)] = array2D[y][x]
         }
      }
   }
   
   func validate(x: Int? = nil, y: Int? = nil) -> Bool {
      return switch (x,y) {
         case (.some(let x), .some(let y)): 0...yMax ~= y && 0...xMax ~= x
         case (.some(let x), _): 0...xMax ~= x
         case (_, .some(let y)): 0...yMax ~= y
         case(.none, .none): false
      }
   }
   
   @discardableResult
   func move(_ heading: Heading? = nil) -> Bool {
      guard let next = point(looking: heading ?? self.heading) else { return false}
      current = next
      return true
   }
   
   func cell(looking heading: Heading? = nil) -> T? {
      guard let next = point(looking: heading ?? self.heading) else {return  nil}
      return grid[next]
   }
   
   func point(looking: Heading) -> Point? {
      switch looking  {
         case .left: return validate(x:current.x - stride) ? Point(current.x - stride, current.y) : nil
         case .right: return validate(x: current.x + stride) ? Point(current.x + stride, current.y) : nil
         case .up: return validate(y: current.y - stride) ? Point(current.x, current.y - stride) : nil
         case.down: return validate(y: current.y + stride) ? Point(current.x, current.y + stride) : nil
      } 
   }
   
   @discardableResult
   func jump(to: Point, heading: Heading) -> Bool {
      guard validate(x: to.x, y: to.y) else {return false}
      current = to
      self.heading = heading
      return true
   }
   
   func set(_ p: Point? = nil, to value: T) {
      grid[p ?? current] = value
   }
}
