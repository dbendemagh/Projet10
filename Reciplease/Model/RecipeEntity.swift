//
//  FavoriteRecipe.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 02/04/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
import CoreData

class RecipeEntity : NSManagedObject {
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [RecipeEntity] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let favoriteRecipes = try? viewContext.fetch(request) else { return [] }
        return favoriteRecipes
    }
    
    //static func add(viewContext: NSManagedObjectContext = AppDelegate.viewContext, name: String, ingredients: [String], id: String, rating: Int, time: Int) {
    static func add(viewContext: NSManagedObjectContext = AppDelegate.viewContext, recipeDetails: RecipeDetails, ingredients: [String]) {
        let recipe = RecipeEntity(context: viewContext)
        recipe.name = recipeDetails.name
        recipe.recipeId = recipeDetails.id
        recipe.rating = recipeDetails.rating.likestoString()
        recipe.time = recipeDetails.totalTimeInSeconds.secondsToString()
        
        IngredientEntity.add(recipe: recipe, ingredients: ingredients)
        
        try? viewContext.save()
    }
}