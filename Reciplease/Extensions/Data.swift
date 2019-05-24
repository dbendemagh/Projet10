//
//  Data.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 20/04/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

extension Data {
    func isImage() -> Bool {
        guard let _ = UIImage(data: self) else { return false }
        return true
    }
}
