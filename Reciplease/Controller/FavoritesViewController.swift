//
//  FavoritesViewController.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 09/04/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var favoriteRecipes: [RecipeEntity] = []
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let detailsVC = segue.destination as? DetailsViewController {
            detailsVC.recipeDetails = recipeDetails
            //detailsVC.ingredients = ingredients
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        favoriteRecipes = RecipeEntity.fetchAll()
        tableView.reloadData()
    }
}

// MARK: TableView DataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteRecipeCell") as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(recipe: favoriteRecipes[indexPath.row])
        
        return cell
    }
}

// MARK: TableView Delegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let recipeId = favoriteRecipes[indexPath.row].recipeId
        let recipe: RecipeEntity = favoriteRecipes[indexPath.row]
        let ingredients = IngredientEntity.fetchIngredients(recipe: recipe)
        let ingredientsDetail = IngredientDetailEntity.fetchIngredientsDetail(recipe: recipe)
        let urlDirections = recipe.urlDirections ?? ""

        if let name = recipe.name,
            let id = recipe.id,
            let time = recipe.time,
            let rating = recipe.rating {
            
            recipeDetails = RecipeDetails(name: name,
                                          id: id,
                                          time: time,
                                          rating: rating,
                                          urlImage: "",
                                          image: recipe.image,
                                          ingredients: ingredients.map({ $0.name ?? ""}),
                                          ingredientsDetail: ingredientsDetail.map({ $0.dosage ?? ""}),
                                          urlDirections: urlDirections,
                                          shoppingList: false)
            
            self.performSegue(withIdentifier: "DetailsVCSegue", sender: self)
        }
    }
}

// MARK: - SearchBar Delegate
extension FavoritesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            favoriteRecipes = RecipeEntity.searchRecipes(searchText: searchText)
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            favoriteRecipes = RecipeEntity.fetchAll()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
