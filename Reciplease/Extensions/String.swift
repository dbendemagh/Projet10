//
//  String.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 17/02/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

extension String {
    var transformToArray: [String] {
        return self.components(separatedBy: .punctuationCharacters).joined().components(separatedBy: " ").filter { !$0.isEmpty }
    }
    
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}
