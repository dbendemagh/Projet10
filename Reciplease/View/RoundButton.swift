//
//  RoundButton.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 21/05/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class RoundButton : UIButton {
    override func didMoveToWindow() {
        self.layer.cornerRadius = 5
    }
}
