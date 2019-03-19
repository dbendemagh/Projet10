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
        backgroundStackView.setBackground()
        setGradientBackground()
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
    }
    
    func setGradientBackground() {
        //let gradientLayer = CAGradientLayer()
        //gradientLayer.frame = recipeImage.bounds
        //gradientLayer.colors = [UIColor.blue, UIColor.green]
        //recipeImage.layer.addSublayer(gradientLayer) //.insertSublayer(gradientLayer, at: 0)
        let gradientLayer = CAGradientLayer()
        print(recipeImage.frame)
        print(gradientView.bounds)
        gradientLayer.frame = recipeImage.bounds //CGRect(x: 10, y: 0, width: 400, height: 80) //recipeImage.bounds
        
        print(gradientLayer.frame)
        print("grad bounds \(gradientLayer.bounds)")
        print(bounds)
        //gradientLayer.colors = [UIColor.white.withAlphaComponent(0.0).cgColor, UIColor.white.withAlphaComponent(1.0).cgColor]
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.black.cgColor]
        //gradientLayer.colors = [UIColor.clear.cgColor, UIColor.blue.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientView.layer.addSublayer(gradientLayer) //layer.insertSublayer(gradientLayer, at: 0) //mask = gradientLayer
        gradientView.alpha = 0.5
    }
    
    
    
    override func layoutMarginsDidChange() {
        //setGradientBackground()
    }
}
