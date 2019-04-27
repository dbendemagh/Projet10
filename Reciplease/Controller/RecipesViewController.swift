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
    var recipeDetails: RecipeDetails?
    var ingredients: [String] = []
    let yummlyService = YummlyService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? DetailsViewController {
            detailsVC.recipeDetails = recipeDetails
            detailsVC.ingredients = ingredients
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
        let recipeId = recipes[indexPath.row].id
        ingredients = recipes[indexPath.row].ingredients
        
        yummlyService.getRecipeDetails(recipeId: recipeId) { (result) in
            switch result {
            case .success(let recipeDetails):
                self.recipeDetails = recipeDetails
                self.performSegue(withIdentifier: "DetailsVCSegue", sender: self)
            case .failure(_):
                self.displayAlert(title: "Network error", message: "Cannot retrieve recipe details")
            }
        }
    }
}
