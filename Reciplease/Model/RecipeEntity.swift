//
//  FavoriteRecipe.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 02/04/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
//import UIKit
import CoreData

class RecipeEntity : NSManagedObject {
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [RecipeEntity] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let favoriteRecipes = try? viewContext.fetch(request) else { return [] }
        return favoriteRecipes
    }
    
    static func isRecipeRegistered(viewContext: NSManagedObjectContext = AppDelegate.viewContext, id: String) -> Bool {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let _ = try? viewContext.fetch(request).first { return true }
        return false
    }
    
    static func fetchRecipe(viewContext: NSManagedObjectContext = AppDelegate.viewContext, recipeId: String) -> RecipeEntity? {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", recipeId)
        guard let favoriteRecipe = try? viewContext.fetch(request).first else { return nil }
        return favoriteRecipe
    }
    
    //static func add(viewContext: NSManagedObjectContext = AppDelegate.viewContext, name: String, ingredients: [String], id: String, rating: Int, time: Int) {
    static func add(viewContext: NSManagedObjectContext = AppDelegate.viewContext, recipeDetails: RecipeDetails, ingredients: [String], image: Data?) {
        let recipe = RecipeEntity(context: viewContext)
        recipe.name = recipeDetails.name
        recipe.id = recipeDetails.id
        recipe.rating = recipeDetails.rating.likestoString()
        recipe.time = recipeDetails.totalTimeInSeconds.secondsToString()
        if let image = image {
            recipe.image = image // UIImage.pngData(image)() as Data? //UIImagePNGRepresentation(image) as Data?
        }
        
        print(ingredients)
        IngredientEntity.add(recipe: recipe, ingredients: ingredients)
        
        try? viewContext.save()
    }
    
    static func delete(viewContext: NSManagedObjectContext = AppDelegate.viewContext, id: String) {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let favoriteRecipe = try? viewContext.fetch(request).first {
            viewContext.delete(favoriteRecipe)
            try? viewContext.save()
        }
    }
}
