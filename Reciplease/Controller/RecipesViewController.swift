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
    let yummlyService = YummlyService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        let recipeId = recipes[indexPath.row].id
        
        //toggleActivityIndicator(shown: true)
        yummlyService.getRecipeDetails(recipeId: recipeId) { (success, recipeDetails) in
            //self.toggleActivityIndicator(shown: false)
            if success {
                if let recipeDetails = recipeDetails {
                    self.recipeDetails = recipeDetails
                }
                
                self.performSegue(withIdentifier: "DetailsVCSegue", sender: self)
            } else {
                self.displayAlert(title: "Network error", message: "Cannot retrieve recipe details")
            }
        }
        
        //performSegue(withIdentifier: "DetailsVCSegue", sender: self)
        
    }
}
