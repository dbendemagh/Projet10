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
    
    func searchRecipes(ingredients: [String], completionHandler: @escaping (Result<Recipes?, Error>) -> Void) {
        guard let url = createURL(ingredients: ingredients) else { return }
        
        yummlySession.request(url: url) { responseData in
            guard responseData.response?.statusCode == 200 else {
                completionHandler(.failure(NetworkError.httpResponseKO))
                return
            }
            guard let data = responseData.data else {
                completionHandler(.failure(NetworkError.noData))
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode(Recipes.self, from: data)
                completionHandler(.success(recipes))
            }
            catch {
                print(error)
                completionHandler(.failure(NetworkError.jsonDecodeError))
            }
        }
    }
    
    func getRecipeDetails(recipeId: String, completionHandler: @escaping (Result<RecipeDetails?, Error>) -> Void) {
        guard let url = createRecipeDetailsURL(recipeId: recipeId) else { return }
            
        yummlySession.request(url: url) { responseData in
            guard responseData.response?.statusCode == 200 else {
                completionHandler(.failure(NetworkError.httpResponseKO))
                return
            }
            guard let data = responseData.data else {
                completionHandler(.failure(NetworkError.noData))
                return
            }
            
            do {
                let recipeDetails = try JSONDecoder().decode(RecipeDetails.self, from: data)
                completionHandler(.success(recipeDetails))
            }
            catch {
                print(error)
                completionHandler(.failure(NetworkError.jsonDecodeError))
            }
        }
    }
    
    func getImage(url: URL, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(NetworkError.httpResponseKO))
                return
            }
            guard let data = data else {
                completionHandler(.failure(NetworkError.noData))
                return
            }
            
            completionHandler(.success(data))
        }
        task.resume()
    }
}
