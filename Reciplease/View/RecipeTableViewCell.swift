//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 26/02/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit
import SDWebImage

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet weak var recipeRating: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    //@IBOutlet weak var viewTest: UIView!
    @IBOutlet weak var backgroundStackView: UIStackView!
    @IBOutlet weak var gradientView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //setGradientBackground()
        //backgroundStackView.setBackground()
        //gradientView.setGradientBackground()
        recipeImage.setGradient()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }
    
    func configure(recipe: Recipe) {
        recipeName.text = recipe.recipeName
        recipeIngredients.text = recipe.ingredients.joined(separator: ", ")
        recipeTime.text = recipe.totalTimeInSeconds.secondsToString()
        recipeRating.text = recipe.rating.likestoString()
        var urlString = recipe.smallImageUrls[0]
        urlString = urlString.dropLast(2) + "360"
        let url = URL(string: urlString)
        //let url = URL(string: "")
        recipeImage?.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Ingredients"), options: .continueInBackground, completed: nil)
        //}
        //recipeImage.setGradient()
        backgroundStackView.setBackground()
    }
    
    func setGradient() {
        let gradientView = UIView(frame: recipeImage.bounds)
        gradientView.backgroundColor = .clear
        gradientView.alpha = 0.7
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.clear.withAlphaComponent(0).cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        gradientView.layer.addSublayer(gradientLayer) //layer.mask = gradientLayer
        recipeImage.addSubview(gradientView)
    }
    
    func setGradientBackground0() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = recipeImage.bounds
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientView.layer.addSublayer(gradientLayer)
        gradientView.alpha = 0.6
    }
    
    
    
    //override func layoutMarginsDidChange() {
        //setGradientBackground()
    //}
}
