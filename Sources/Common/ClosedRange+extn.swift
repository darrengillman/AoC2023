//
//  File.swift
//  
//
//  Created by Darren Gillman on 06/12/2023.
//

import Foundation

extension ClosedRange where Bound == Int {
   func removing(_ r:Self) -> (removed: Self?, remaining: [Self])  {
      guard overlaps(r) else {return (nil, [self])}
      switch (r.lowerBound <= lowerBound, r.upperBound >= upperBound) {
         case (true, true): return (self, [])
         case (true, false): return( lowerBound...r.upperBound, [r.upperBound+1...upperBound])
         case (false, true): return (r.lowerBound...upperBound, [lowerBound...r.lowerBound-1])
         case (false, false): return (r, [ lowerBound...r.lowerBound-1, r.upperBound+1...upperBound])
      }
   }  
}
