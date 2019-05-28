//
//  DetailsViewController.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 06/03/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientsTitle: UILabel!
    @IBOutlet weak var recipeRating: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var backgroundStackView: UIStackView!
    @IBOutlet weak var shoppingListButton: UIBarButtonItem!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var recipeDetails = RecipeDetails(name: "",
                                      id: "",
                                      time: "",
                                      rating: "",
                                      urlImage: "",
                                      image: nil,
                                      ingredients: [],
                                      ingredientsDetail: [],
                                      urlDirections: "")
    
    let yummlyService = YummlyService()
    var isFavorite: Bool = false
    
    // MARK: - Init Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        initScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setFavoriteButton()
        setShoppingListButton()
        setShoppinListTab()
    }
    
    func initScreen() {
        toggleActivityIndicator(shown: false)
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        ingredientsTitle.font = UIFont(name: Font.reciplease, size: 17)
        backgroundStackView.setBackground()
        
        recipeName.text = recipeDetails.name
        recipeRating.text = recipeDetails.rating
        recipeTime.text = recipeDetails.time
        
        setRecipeImage()
        recipeImage.setGradient()
    }
    
    // MARK: - Methods
    
    private func setRecipeImage() {
        if let image = recipeDetails.image {
            recipeImage.image = UIImage(data: image)
            return
        } else {
            guard let url = URL(string: recipeDetails.urlImage) else { return }
            toggleActivityIndicator(shown: true)
            yummlyService.getImage(url: url) { (result) in
                DispatchQueue.main.async {
                    self.toggleActivityIndicator(shown: false)
                    switch result {
                    case .success(let data):
                        self.recipeDetails.image = data
                        self.recipeImage.image = UIImage(data: data)
                    case .failure(_):
                        self.recipeImage.image = UIImage(named: File.defaultImage)
                    }
                }
            }
        }
    }
    
    private func toggleActivityIndicator(shown: Bool) {
        activityIndicator.isHidden = !shown
        if shown {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func setFavoriteButton() {
        if RecipeEntity.isRecipeRegistered(id: recipeDetails.id) {
            isFavorite = true
            favoriteButton.tintColor = UIColor.Reciplease.green
            shoppingListButton.isEnabled = true
        } else {
            isFavorite = false
            favoriteButton.tintColor = .white
            shoppingListButton.isEnabled = false
        }
    }
    
    private func setShoppingListButton() {
        if RecipeEntity.isInShoppingList(id: recipeDetails.id) {
            shoppingListButton.tintColor = UIColor.Reciplease.green
        } else {
            shoppingListButton.tintColor = .white
        }
    }
    
    private func setShoppinListTab() {
        let ingredients = IngredientDetailEntity.fetchIngredientsInShoppingList()
        
        // Number of ingredients to buy
        if let tabBarItems = tabBarController?.tabBar.items {
            tabBarItems[2].badgeValue = ingredients.count > 0 ? String(ingredients.count) : nil
        }
    }

    // MARK: - Action buttons
    
    @IBAction func shoppingListButtonPressed(_ sender: Any) {
        RecipeEntity.toggleShoppingList(id: recipeDetails.id)
        setShoppingListButton()
        setShoppinListTab()
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        if isFavorite {
            RecipeEntity.delete(id: recipeDetails.id)
        } else {
            RecipeEntity.add(recipeDetails: recipeDetails)
        }
        setFavoriteButton()
        setShoppingListButton()
        setShoppinListTab()
    }
    
    @IBAction func getDirectionsButtonPressed(_ sender: Any) {
        guard let url = URL(string: recipeDetails.urlDirections) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}

// MARK: - TableView Datasource

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeDetails.ingredientsDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.setDisplay()
        cell.textLabel?.text = "- \(recipeDetails.ingredientsDetail[indexPath.row])"

        return cell
    }
}

// MARK: - TableView Delegate

extension DetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
