//
//  ViewController.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 04/02/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    
    var ingredients: [String] = []
    let defaults = UserDefaults.standard
    let yummlyService = YummlyService()
    
    var recipes: Recipes?    // = []
    
    var ingredientsBackup: [String] {
        get {
            guard let list = defaults.array(forKey: UserDefaultsKeys.ingredientsList) as? [String] else { return [] }
            return list
        }
        set {
            defaults.set(ingredients, forKey: UserDefaultsKeys.ingredientsList)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleActivityIndicator(shown: false)
        
        ingredients = ingredientsBackup
    }
    
    
    // MARK: - Methods
    
    func searchRecipes() {
        toggleActivityIndicator(shown: true)
        yummlyService.searchRecipes(ingredients: ingredients) { (success, recipes) in
            self.toggleActivityIndicator(shown: false)
            if success {
                if let recipes = recipes {
                    self.recipes = recipes
                }
                
                self.performSegue(withIdentifier: "RecipesVCSegue", sender: self)
            } else {
                self.displayAlert(title: "Network error", message: "Cannot retrieve recipes")
            }
        }
    }
    
    // display Activity indicator
    private func toggleActivityIndicator(shown: Bool) {
        searchButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipesVC = segue.destination as? RecipesViewController, let recipes = recipes {
            recipesVC.recipes = recipes.matches
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        guard let ingredientsText = ingredientsTextField.text else { return }
        
        let list = ingredientsText.transformToArray
        
        for ingredient in list {
            ingredients.append(ingredient.firstUppercased)
        }
        
        ingredients.sort()
        
        ingredientsBackup = ingredients
        
        tableView.reloadData()
        
        ingredientsTextField.text = ""
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        ingredients.removeAll()
        ingredientsBackup = ingredients
        
        tableView.reloadData()
    }
    
    @IBAction func searchRecipesButtonPressed(_ sender: Any) {
        if !ingredients.isEmpty {
            searchRecipes()
        } else {
            displayAlert(title: "No ingredients", message: "Add ingredients to search")
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        let ingredient = ingredients[indexPath.row]
        cell.textLabel?.text = "- \(ingredient)"
        cell.textLabel?.font = UIFont(name: "Chalkduster", size: 17)
        
        return cell
    }
}
