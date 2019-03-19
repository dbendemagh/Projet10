//
//  Float.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 19/03/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

extension Float {
    func pointToComma() -> String {
        return String(self).replacingOccurrences(of: ".", with: ",")
    }
}
