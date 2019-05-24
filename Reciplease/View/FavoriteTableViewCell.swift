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
    }
    
    func configure(recipe: RecipeEntity) {
        recipeName.text = recipe.name
        let ingredients = recipe.ingredients?.allObjects as! [IngredientEntity]
        recipeIngredients.text = ingredients.map({$0.name ?? ""}).joined(separator: ", ")
        recipeTime.text = recipe.time
        recipeRating.text = recipe.rating
        if let data = recipe.image as Data? {
            recipeImage.image = UIImage(data: data)
        } else {
            recipeImage.image = UIImage(named: File.defaultImage)
        }
        recipeImage.setGradient()
    }
}


