   //
   //  File.swift
   //  
   //
   //  Created by Darren Gillman on 03/01/2024.
   //

import Foundation

class Grid<T: CustomStringConvertible> {
   enum Heading: Int, CaseIterable {
      case left, right, up, down
      
      var reverse: Self {
         switch self {
            case .left:  .right
            case .right: .left
            case .up: .down
            case .down: .up
         }
      }
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

extension Grid where T == Int {
   struct State: CustomStringConvertible {
      let point: Point
      let cost: Int
      let heading: Heading
      let consecutiveMoves: Int
      
      var description: String {
         "\(point): cost: \(cost), heading: \(heading), inLine: \(consecutiveMoves)"
      }
   }
   
   
   func lcr(from: Point, to: Point, includeStartWeight: Bool = false, minStraight: Int = 0, maxStraight: Int = Int.max) -> Int {
      var visited: [Point: Int] = [:]
      var queue: [Int: [State]] = [(includeStartWeight ? grid[from]! : 0) : [State(point: from, cost: 0, heading: .right, consecutiveMoves: 0)]]
      
      var nextSteps: [State]? {
         guard let lowestCost = queue.keys.min() else {return nil}
         guard let group =  queue[lowestCost] else {return nil}
         queue[lowestCost] = nil
         return group
      }

      while let nextSteps {
         for step in nextSteps {
            visited[step.point] = step.cost
            
            jump(to: step.point, heading: step.heading)
            let viableStates : [State] = Heading
               .allCases
               .filter{$0 != step.heading.reverse}
               .compactMap{ newHeading in
                  guard let validPoint = self.point(looking: newHeading) else {return nil}
                  guard visited[validPoint, default: Int.max] > (step.cost + grid[validPoint]!) else {return nil}
//                  guard !visited.keys.contains(validPoint) else {return nil}
                  let straightLineMoves = newHeading == step.heading ? step.consecutiveMoves + 1 : 1
                  guard straightLineMoves >= minStraight && straightLineMoves <= maxStraight else {return nil}
                  return State(point: validPoint, 
                               cost: step.cost + grid[validPoint]!,
                               heading: newHeading, 
                               consecutiveMoves: straightLineMoves 
                  )
               }
            
            assert(viableStates.count < 4)
            
            for newState in viableStates {
               if newState.point == to {
                  print("out: \(newState)")
                  return newState.cost
               }
               queue[newState.cost, default: [] ].append(newState)
            }
         }
//         print(visited)
//         print()
      }
      fatalError("Exit point not found")
   }
}
