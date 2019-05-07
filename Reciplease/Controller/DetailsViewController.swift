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
    
    var recipeDetails = RecipeDetails(name: "", id: "", time: "", rating: "", urlImage: "", image: nil, ingredients: [], ingredientsDetail: [], urlDirections: "")
    
    var isFavorite: Bool = false
    
    let yummlyService = YummlyService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setFavoriteButton()
    }
    
    func initScreen() {
        toggleActivityIndicator(shown: false)
        
        ingredientsTitle.font = UIFont(name: Font.reciplease, size: 17)
        backgroundStackView.setBackground()
        
        recipeName.text = recipeDetails.name
        recipeRating.text = recipeDetails.rating
        recipeTime.text = recipeDetails.time    // totalTimeInSeconds.secondsToString()
            
        setImage() //urlImage: recipeDetails.urlDirections) // recipeDetails.images[0].hostedLargeUrl)
        
        recipeImage.setGradient()
    }
    
    private func setImage() {//urlImage: String) {
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
            //self.recipeImage.setGradient()
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
           favoriteButton.tintColor = .recipleaseGreen
        } else {
            isFavorite = false
            favoriteButton.tintColor = .white
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
        
        gradientView.layer.addSublayer(gradientLayer)
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
        if isFavorite {
            RecipeEntity.delete(id: recipeDetails.id)
        } else {
            RecipeEntity.add(recipeDetails: recipeDetails) //, ingredients: recipeDetails.ingredients, image: dataImage)
        }
        setFavoriteButton()
    }
    
    @IBAction func getDirectionsButtonPressed(_ sender: Any) {
        //guard !recipeDetails.urlDirections.isEmpty else { return }
        guard let url = URL(string: recipeDetails.urlDirections) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}

extension DetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeDetails.ingredientsDetail.count // ingredientLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = "- \(recipeDetails.ingredientsDetail[indexPath.row])"
        cell.textLabel?.font = UIFont(name: Font.reciplease, size: 13)
        
        return cell
    }
}
