//
//  String.swift
//  gdprConsentStringSwift
//
//  Created by Daniel Kanaan on 4/17/18.
//  Copyright © 2018 Daniel Kanaan. All rights reserved.
//

import Foundation

extension String {
    
    static let base64PaddingCharacterSet:CharacterSet = CharacterSet(charactersIn: "=")
    
   /* var base64Padded:String {
        get {
            return self.padding(toLength: ((self.count + 3) / 4) * 4,withPad: "=",startingAt: 0)
        }
    }
    */
    var base64PaddedWithA:String {
        get {
            return self.padding(toLength: ((self.count + 3) / 4) * 4,withPad: "A",startingAt: 0)
        }
    }
    
    var base64PaddingRemoved:String {
        get {
            return self.trimmingCharacters(in: String.base64PaddingCharacterSet)
        }
    }
    
}
