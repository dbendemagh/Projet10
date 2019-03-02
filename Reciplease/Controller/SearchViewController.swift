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
    
    var ingredients: [String] = []
    let defaults = UserDefaults.standard
    let yummlyService = YummlyService()
    
    var recipes: [Recipe] = []
    
    var ingredientsBackup: [String] {
        get {
            guard let list = defaults.array(forKey: ingredientsListKey) as? [String] else { return [] }
            return list
        }
        set {
            defaults.set(ingredients, forKey: ingredientsListKey)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredients = ingredientsBackup
    }
    
    
    // MARKS: - Methods
    
    func searchRecipes() {
        yummlyService.searchRecipes(ingredients: ingredients) { (success, recipes) in
            if success {
                print("if success")
                if let recipes = recipes {
                    self.recipes = recipes
                }
                
                self.performSegue(withIdentifier: "RecipesVCSegue", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipesVC = segue.destination as? RecipesViewController {
            recipesVC.recipes = recipes
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
            // alert
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
