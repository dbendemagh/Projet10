//
//  FavoriteTableViewCell.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 09/04/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet weak var recipeRating: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var backgroundStackView: UIStackView!
    @IBOutlet weak var gradientView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        
    }
    
    func configure(recipe: RecipeEntity) {
        recipeName.text = recipe.name
        let ingredients = recipe.ingredients?.allObjects as! [IngredientEntity]
        print(ingredients)
        recipeIngredients.text = ingredients.map({$0.name ?? ""}).joined(separator: ", ")
        recipeTime.text = recipe.time
        recipeRating.text = recipe.rating
        if let data = recipe.image as Data? {
            recipeImage.image = UIImage(data: data)
        } else {
            recipeImage.image = UIImage(named: "Ingredients")
        }
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
        
        gradientView.layer.addSublayer(gradientLayer)
        recipeImage.addSubview(gradientView)
    }
}


