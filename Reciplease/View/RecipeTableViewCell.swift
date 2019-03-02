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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(recipe: Recipe) {
        recipeName.text = recipe.recipeName
        recipeIngredients.text = recipe.ingredients.joined(separator: ", ")
        recipeTime.text = String(recipe.totalTimeInSeconds / 60)
        recipeRating.text = String(recipe.rating)
        var urlString = recipe.smallImageUrls[0]
        urlString = urlString.dropLast(2) + "360"
        let url = URL(string: urlString)
        //let url = URL(string: "")
        recipeImage?.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Ingredients"), options: .continueInBackground, completed: nil)
        //}
    }
}
