//
//  File.swift
//  
//
//  Created by Darren Gillman on 15/12/2023.
//

import Foundation

extension Array where Element == [String] {
   func print() {
      self.forEach{
         Swift.print($0.joined(separator: " "))
      }
   }
}

extension Array where Element == [Character] {
   func print() {
      self.forEach{
         Swift.print($0.map{$0.asString}.joined(separator: " "))
      }
   }
}
