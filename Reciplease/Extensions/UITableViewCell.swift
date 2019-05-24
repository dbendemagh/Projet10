//
//  UITableViewCell.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 23/05/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func setDisplay() {
        self.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.textLabel?.font = UIFont(name: Font.reciplease, size: 17)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkGray
        self.selectedBackgroundView = backgroundView
        
        self.textLabel?.numberOfLines = 0
    }
}
