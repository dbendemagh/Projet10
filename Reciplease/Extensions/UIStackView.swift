//
//  UIStackView.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 15/03/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

extension UIStackView {
    func setBackground() {
        let backgroundView = UIView(frame: .zero)
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.4
        backgroundView.layer.cornerRadius = 5.0
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(backgroundView, at: 0)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
    }
}
