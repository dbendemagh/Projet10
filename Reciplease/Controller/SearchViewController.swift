//
//  ViewController.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 04/02/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!
    
    // MARK: - Properties
    
    var ingredients: [String] = []
    let yummlyService = YummlyService()
    var recipes: YummlyRecipes?
    var isEditingIngredients: Bool = false
    let userDefaults = UserDefaults.standard
    
    // MARK: - Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        toggleActivityIndicator(shown: false)
        
        ingredients = userDefaults.loadIngredients()
        
        setShoppinListTab()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let recipesVC = segue.destination as? RecipesViewController, let recipes = recipes {
            recipesVC.recipes = recipes.matches
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonPressed(_ sender: Any) {
        guard let ingredientsText = ingredientsTextField.text, !ingredientsText.isEmpty else {
            ingredientsTextField.becomeFirstResponder()
            displayAlert(title: "Nothing to add", message: "Please add ingredients")
            return
        }
        
        let list = ingredientsText.transformToArray
        
        for ingredient in list {
            ingredients.append(ingredient.firstUppercased)
        }
        
        ingredients.sort()
        userDefaults.saveIngredients(list: ingredients)
        
        tableView.reloadData()
        
        ingredientsTextField.text = ""
        ingredientsTextField.resignFirstResponder()
        isEditingIngredients = false
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        ingredients.removeAll()
        userDefaults.saveIngredients(list: ingredients)
        tableView.reloadData()
    }
    
    @IBAction func searchRecipesButtonPressed(_ sender: Any) {
        if !ingredients.isEmpty {
            searchRecipes()
        } else {
            displayAlert(title: "Nothing to search", message: "Please add ingredients")
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        ingredientsTextField.resignFirstResponder()
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
            self.userDefaults.saveIngredients(list: self.ingredients)
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

// MARK: - TextField Delegate

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientsTextField.resignFirstResponder()
        return true
    }
}
