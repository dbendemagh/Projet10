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
    var filteredFavoriteRecipes: [RecipeEntity] = []
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
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        setupNavBar()
    }
    
    func setupNavBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search recipes"
        searchController.searchBar.tintColor = .white
        //searchController.searchBar.color = .white
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsVC = segue.destination as? DetailsViewController {
            detailsVC.recipeDetails = recipeDetails
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        favoriteRecipes = RecipeEntity.fetchAll()
        tableView.reloadData()
    }
    
    // MARK: - Search Bar methods
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}

// MARK: TableView DataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredFavoriteRecipes.count
        }
        
        return favoriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteRecipeCell") as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        
        if isFiltering() {
            cell.configure(recipe: filteredFavoriteRecipes[indexPath.row])
        } else {
            cell.configure(recipe: favoriteRecipes[indexPath.row])
        }
        
        return cell
    }
}

// MARK: TableView Delegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe: RecipeEntity = isFiltering() ?
            filteredFavoriteRecipes[indexPath.row] : favoriteRecipes[indexPath.row]
        
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

// MARK: - Search Bar
extension FavoritesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            
            filteredFavoriteRecipes = favoriteRecipes.filter({ (recipeEntity) -> Bool in
                guard let name = recipeEntity.name else { return false }
                return name.lowercased().contains(searchText.lowercased())
            })
            
            tableView.reloadData()
        }
    }
}
