//
//  RecipesViewController.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 25/02/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipes: [Recipe] = []
    var recipeDetails = RecipeDetails(name: "",
                                      id: "",
                                      time: "",
                                      rating: "",
                                      urlImage: "",
                                      image: nil,
                                      ingredients: [],
                                      ingredientsDetail: [],
                                      urlDirections: "",
                                      shoppingList: false)
    
    let yummlyService = YummlyService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? DetailsViewController {
            detailsVC.recipeDetails = recipeDetails
        }
    }
}

extension RecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell") as? RecipeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(recipe: recipes[indexPath.row])
        
        return cell
    }
}

extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        
        yummlyService.getRecipeDetails(recipeId: recipe.id) { (result) in
            switch result {
            case .success(let recipeDetails):
                self.recipeDetails = RecipeDetails(name: recipeDetails.name,
                                                    id: recipeDetails.id,
                                                    time: recipeDetails.totalTimeInSeconds.secondsToString(),
                                                    rating: recipeDetails.rating.likestoString(),
                                                    urlImage: recipeDetails.images[0].hostedLargeUrl,
                                                    image: nil,
                                                    ingredients: recipe.ingredients,
                                                    ingredientsDetail: recipeDetails.ingredientLines,
                                                    urlDirections: recipeDetails.source.sourceRecipeUrl,
                                                    shoppingList: false)
                self.performSegue(withIdentifier: "DetailsVCSegue", sender: self)
            case .failure(_):
                self.displayAlert(title: "Network error", message: "Cannot retrieve recipe details")
            }
        }
    }
}
