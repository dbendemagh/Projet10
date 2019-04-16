//
//  UIImage.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 08/04/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

//import Foundation
import UIKit

extension UIImageView {
    func setGradient() {
        //let width = size.width
        //let height = size.height
        //let gradientView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size)) //UIView(frame: )
        let gradientView = UIView(frame: bounds)
        gradientView.backgroundColor = .clear
        gradientView.alpha = 0.7
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.clear.withAlphaComponent(0).cgColor, UIColor.darkGray.cgColor]
        gradientLayer.locations = [0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        gradientView.layer.addSublayer(gradientLayer) //layer.mask = gradientLayer
        // .addSubview(gradientView)
        addSubview(gradientView)
    }}
