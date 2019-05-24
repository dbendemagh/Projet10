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
    var isEditingIngredients: Bool = false
    
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
        navigationController?.navigationBar.barStyle = .black
        toggleActivityIndicator(shown: false)
        
        ingredients = ingredientsBackup
        
        setShoppinListTab()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Methods
    
    private func setShoppinListTab() {
        let ingredients = IngredientDetailEntity.fetchIngredientsInShoppingList()
        
        if let tabBarItems = tabBarController?.tabBar.items {
            tabBarItems[2].badgeValue =  ingredients.count > 0 ? String(ingredients.count) : nil
        }
    }

    private func searchRecipes() {
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
        if isEditingIngredients && !ingredientsText.isEmpty {
            ingredientsTextField.text = ingredientsText + ", " + name
        } else {
            ingredientsTextField.text = name
        }
        isEditingIngredients = true
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
        isEditingIngredients = false
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

// MARK: - TableView DataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.setDisplay()
        let ingredient = ingredients[indexPath.row]
        cell.textLabel?.text = "- \(ingredient)"
        return cell
    }
}

// MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "EDIT") { (rowAction, indexPath) in
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
