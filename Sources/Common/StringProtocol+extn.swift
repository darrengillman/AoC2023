//
//  File.swift
//  
//
//  Created by Darren Gillman on 09/12/2023.
//

import Foundation
extension StringProtocol {
   var asString: String {String(self)}
}

extension String {
   func replacingFirstOccurrence(of char: Character , with newChar: Character) -> String {
      var a = Array(self)
      guard let i = a.firstIndex(of: char) else {return self }
      a[i] = newChar
      return String(a)
   }
}


extension String.Element {
   var asString: String {String(self)}
}
