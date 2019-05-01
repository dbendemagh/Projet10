//
//  Constants.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 13/02/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

struct UserDefaultsKeys {
    static let ingredientsList = "IngredientsList"
}

struct URLYummly {
    static let endPoint = "https://api.yummly.com/v1/api/"
    static let recipes = "recipes?"
    static let recipe = "recipe/"
    static let appId = "_app_id=c7de48f7"
    static let appKey = "_app_key=ead08c9a5260d1abdf6673a3fd7bd846"
    static let allowedIngredient = "allowedIngredient="
}

struct File {
    static let recipes = "Recipes"
    static let recipeDetails = "RecipeDetails"
    static let defaultImage = "Ingredients"
}

struct Font {
    static let reciplease = "Chalkduster"
}

enum NetworkError : Error {
    case httpResponseKO
    case incorrectURL
    case incorrectData
    case noData
    case jsonDecodeError
}
