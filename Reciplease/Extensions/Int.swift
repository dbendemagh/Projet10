//
//  Int.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 19/03/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

extension Int {
    // Number of likes
    func likestoString() -> String {
        if self > 1000 {
            let floatLikes: Float = Float(self) / 1000
            return floatLikes.pointToComma() + "k"
        } else {
            return String(self)
        }
    }
    
    // Cooking time
    func secondsToString() -> String {
        let hours: Int = self / 3600
        let minutes: Int = (self / 60) % 60
        
        var formatedTime: String = ""
        
        if hours > 0 {
            formatedTime = String(hours) + "h"
        }
        
        if minutes > 0 {
            formatedTime.append(String(minutes) + "m")
        }
        
        print("\(self) \(formatedTime)")
        
        return formatedTime
    }
}
