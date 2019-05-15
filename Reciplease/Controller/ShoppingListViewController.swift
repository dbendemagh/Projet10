//
//  ShoppingListViewController.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 12/05/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipes = RecipeEntity.fetchRecipesInShoppingList()
    var ingredients = IngredientDetailEntity.fetchIngredientsInShoppingList()
    
    var shoppingList: [[IngredientDetailEntity]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initShoppingList()
        tableView.reloadData()
        setShoppingListTab()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func initShoppingList() {
        shoppingList.removeAll()
        
        recipes = RecipeEntity.fetchRecipesInShoppingList()
        
        for recipe in recipes {
            let ingredients = IngredientDetailEntity.fetchIngredientsDetail(recipe: recipe)
            shoppingList.append(ingredients)
        }
    }
    
    private func setShoppingListTab() {
        let ingredients = IngredientDetailEntity.fetchIngredientsInShoppingList()
        
        if let tabBarItems = tabBarController?.tabBar.items {
            if ingredients.count > 0 {
                tabBarItems[2].badgeValue = String(ingredients.count)
            } else {
                tabBarItems[2].badgeValue = nil
            }
        }
    }
}

// MARK: - TableView Datasource
extension ShoppingListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList[section].count
    }
    
    //func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //let label  = UILabel()
        //label.text = "recipes"
        //return recipes[section].name
    //}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath)
        
        let recipe = shoppingList[indexPath.section] //[indexPath.row] {
        let ingredient = recipe[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        //cell.textLabel?.text = "\(shoppingList[indexPath.section][indexPath.row].dosage ?? "")"
        cell.textLabel?.text = "\(ingredient.dosage ?? "")"
        cell.textLabel?.font = UIFont(name: Font.reciplease, size: 14)
        cell.textLabel?.textColor = .white
        
        if ingredient.purchased {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}

// MARK: - TableView Delegate
extension ShoppingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label  = UILabel()
        label.text = " \(recipes[section].name ?? "")"
        label.textColor = .white
        label.backgroundColor = UIColor.Reciplease.green
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = shoppingList[indexPath.section][indexPath.row]
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            IngredientDetailEntity.setPurchased(ingredient: ingredient, isPurchased: false)
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            IngredientDetailEntity.setPurchased(ingredient: ingredient, isPurchased: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        setShoppingListTab()
    }
}
