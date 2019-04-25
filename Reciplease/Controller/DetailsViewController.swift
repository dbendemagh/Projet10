//
//  DetailsViewController.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 06/03/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var recipeName: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var ingredientsTitle: UILabel!
    @IBOutlet weak var recipeRating: UILabel!
    @IBOutlet weak var recipeTime: UILabel!
    @IBOutlet weak var backgroundStackView: UIStackView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var recipeDetails: RecipeDetails?
    var ingredients: [String] = []
    var image: UIImage?
    var isFavorite: Bool = false
    var dataImage: Data?
    
    let yummlyService = YummlyService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setFavoriteButton()
    }
    
    func initScreen() {
        
        ingredientsTitle.font = UIFont(name: Font.reciplease, size: 17)
        backgroundStackView.setBackground()
        //var url = URL(string: "")
        
        if let recipeDetails = recipeDetails {
            recipeName.text = recipeDetails.name
            recipeRating.text = recipeDetails.rating.likestoString()
            recipeTime.text = recipeDetails.totalTimeInSeconds.secondsToString()
            
            let urlString = recipeDetails.images[0].hostedLargeURL //recipe.smallImageUrls[0]
            //urlString = urlString.dropLast(2) + "360"
            guard let url = URL(string: urlString) else { return }
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            yummlyService.getImage(url: url) { (result) in
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    switch result {
                    case .success(let data):
                        self.dataImage = data
                        self.recipeImage.image = UIImage(data: data)
                    case .failure(_):
                        self.recipeImage.image = UIImage(named: "Ingredients")
                    }
                    self.recipeImage.setGradient()
                }
                
            }
        }
        
//
        
        //recipeImage?.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "Ingredients"), options: .continueInBackground, completed: nil)
        //gradientBackground.setGradientBackground()
        //setGradient()
        recipeImage.setGradient()
        //updateFavoriteButton()
        
    }
    
    private func setFavoriteButton() {
        if let recipeDetails = recipeDetails {
            //if (RecipeEntity.fetchRecipe(recipeId: recipeDetails.id) == nil) {
            if RecipeEntity.isRecipeRegistered(id: recipeDetails.id) {
                isFavorite = true
               favoriteButton.tintColor = .green
            } else {
                isFavorite = false
                favoriteButton.tintColor = .white
            }
        }
    }
    
    func setGradient() {
        let gradientView = UIView(frame: recipeImage.bounds)
        gradientView.backgroundColor = .clear
        gradientView.alpha = 0.7
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.clear.withAlphaComponent(0).cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        gradientView.layer.addSublayer(gradientLayer) //layer.mask = gradientLayer
        recipeImage.addSubview(gradientView)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func favoriteButtonPressed(_ sender: UIBarButtonItem) {
        //if let recipeDetails = recipeDetails, let image = recipeImage.image {
        if let recipeDetails = recipeDetails {
            if isFavorite {
                RecipeEntity.delete(id: recipeDetails.id)
            } else {
                RecipeEntity.add(recipeDetails: recipeDetails, ingredients: ingredients, image: dataImage)
                //RecipeEntity.add(recipeDetails: recipeDetails, ingredients: ingredients, image: recipeImage.image)
            }
        }
        setFavoriteButton()
    }
    
    @IBAction func getDirectionsButtonPressed(_ sender: Any) {
        guard let urlString = recipeDetails?.source.sourceRecipeURL else { return }
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let recipeDetails = recipeDetails {
            return recipeDetails.ingredientLines.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        if let recipeDetails = recipeDetails {//
            //recipe.ingredients[indexPath.row] //?.ingredients ingredients[indexPath.row]
            cell.textLabel?.text = "- \(recipeDetails.ingredientLines[indexPath.row])"
            cell.textLabel?.font = UIFont(name: Font.reciplease, size: 13)
        }
        return cell
    }
}
