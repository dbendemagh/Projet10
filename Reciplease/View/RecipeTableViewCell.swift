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
    @IBOutlet weak var backgroundStackView: UIStackView!
    @IBOutlet weak var gradientView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(recipe: Recipe) {
        recipeName.text = recipe.recipeName
        recipeIngredients.text = recipe.ingredients.joined(separator: ", ")
        recipeTime.text = recipe.totalTimeInSeconds.secondsToString()
        recipeRating.text = recipe.rating.likestoString()
        var urlString = recipe.smallImageUrls[0]
        urlString = urlString.dropLast(2) + "360"
        let url = URL(string: urlString)
        recipeImage?.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Recipe-Placeholder"), options: .continueInBackground, completed: nil)
        recipeImage.setGradient()
        backgroundStackView.setBackground()
    }
}
