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
    var recipes: YummlyRecipes?
    var editionMode: Bool = false
    
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
        yummlyService.searchRecipes(ingredients: ingredients) { (result) in
            self.toggleActivityIndicator(shown: false)
            switch result {
            case .success(let recipes):
                self.recipes = recipes
                self.performSegue(withIdentifier: "RecipesVCSegue", sender: self)
            case .failure(_):
                self.displayAlert(title: "Network error", message: "Cannot retrieve recipes")
            }
        }
    }
    
    // Display Activity indicator
    private func toggleActivityIndicator(shown: Bool) {
        searchButton.isHidden = shown
        activityIndicator.isHidden = !shown
    }
    
    private func editIngredient(name: String) {
        let ingredientsText = self.ingredientsTextField.text ?? ""
        if editionMode == true && !ingredientsText.isEmpty {
            ingredientsTextField.text = ingredientsText + ", " + name
        } else {
            ingredientsTextField.text = name
        }
        editionMode = true
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
        editionMode = false
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
        cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.textLabel?.font = UIFont(name: "Chalkduster", size: 17)
        
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "EDIT") { (rowAction, indexPath) in
//            let ingredientsText = self.ingredientsTextField.text ?? ""
//            if self.editionMode == true && !ingredientsText.isEmpty {
//                self.ingredientsTextField.text = ingredientsText + ", " + self.ingredients[indexPath.row]
//            } else {
//                self.ingredientsTextField.text = self.ingredients[indexPath.row]
//            }
            self.editIngredient(name: self.ingredients[indexPath.row])
            self.ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        editAction.backgroundColor = UIColor.Reciplease.green
        
        return [editAction]
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
