//
//  YummlyService.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 19/02/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

class YummlyService {
    private var yummlySession: YummlySession
    
    init(yummlySession: YummlySession = YummlySession()) {
        self.yummlySession = yummlySession
    }
    
    func createURL(ingredients: [String]) -> URL? {
        var urlString: String = URLYummly.endPoint + URLYummly.recipes + URLYummly.appId + "&" + URLYummly.appKey + "&"
        
        for ingredient in ingredients {
            urlString += URLYummly.allowedIngredient + ingredient.lowercased() + "&"
        }
        
        urlString = String(urlString.dropLast())
        
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
    func createRecipeDetailsURL(recipeId: String) -> URL? {
        let urlString: String = URLYummly.endPoint + URLYummly.recipe + recipeId + "?" + URLYummly.appId + "&" + URLYummly.appKey
        
        guard let url = URL(string: urlString) else { return nil }
        
        return url
    }
    
    func searchRecipes(ingredients: [String], completionHandler: @escaping (Bool, [Recipe]?) -> Void) {
        if let url = createURL(ingredients: ingredients) {
        
            yummlySession.request(url: url) { responseData in
                print("verif data")
                guard responseData.response?.statusCode == 200 else {
                    completionHandler(false, nil)
                    return
                }
                guard let data = responseData.data else {
                    completionHandler(false, nil)
                    return
                }
                print(responseData)
                
//                do {
//                    let resp = try JSONDecoder().decode(Recipes.self, from: data)
//                    print(resp.matches[0].recipeName)
//                }
//                catch {
//                    print(error)
//                }
                
                
                guard let recipes = try? JSONDecoder().decode(Recipes.self, from: data) else {
                    completionHandler(false, nil)
                    return
                }
                print(recipes.matches.count)
                completionHandler(true, recipes.matches)
                
            }
        }
    }
    
    func getRecipeDetails(recipeId: String, completionHandler: @escaping (Bool, RecipeDetails?) -> Void) {
        if let url = createRecipeDetailsURL(recipeId: recipeId) {
            
            yummlySession.request(url: url) { responseData in
                print("verif data")
                guard responseData.response?.statusCode == 200 else {
                    completionHandler(false, nil)
                    return
                }
                guard let data = responseData.data else {
                    completionHandler(false, nil)
                    return
                }
                print(responseData)
                
                do {
                    let resp = try JSONDecoder().decode(RecipeDetails.self, from: data)
                }
                catch {
                    print(error)
                }
                
                guard let recipeDetails = try? JSONDecoder().decode(RecipeDetails.self, from: data) else {
                    completionHandler(false, nil)
                    return
                }
                //print(recipes.matches.count)
                completionHandler(true, recipeDetails)
            }
        }
    }
}
