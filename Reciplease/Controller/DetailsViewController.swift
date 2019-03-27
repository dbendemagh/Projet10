//
//  DetailsViewController.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 06/03/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientsTitle: UILabel!
    @IBOutlet weak var gradientBackground: UIView!
    @IBOutlet weak var recipeRating: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var backgroundStackView: UIStackView!
    
    var recipeDetails: RecipeDetails?
    var ingredients: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initScreen()
    }
    
    func initScreen() {
        
        ingredientsTitle.font = UIFont(name: "Chalkduster", size: 17)
        
        var url = URL(string: "")
        if let recipeDetails = recipeDetails {
            recipeName.text = recipeDetails.name
            let urlString = recipeDetails.images[0].hostedLargeURL //recipe.smallImageUrls[0]
            //urlString = urlString.dropLast(2) + "360"
            url = URL(string: urlString)
            
            backgroundStackView.setBackground()
            recipeRating.text = recipeDetails.rating.likestoString()
            recipeTime.text = recipeDetails.totalTimeInSeconds.secondsToString()
        }
        
        recipeImage?.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Ingredients"), options: .continueInBackground, completed: nil)
        gradientBackground.setGradientBackground()
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let recipeDetails = recipeDetails {
            return recipeDetails.ingredientLines.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        if let recipeDetails = recipeDetails {//
            //recipe.ingredients[indexPath.row] //?.ingredients ingredients[indexPath.row]
            cell.textLabel?.text = "- \(recipeDetails.ingredientLines[indexPath.row])"
            cell.textLabel?.font = UIFont(name: "Chalkduster", size: 13)
        }
        return cell
    }
}
