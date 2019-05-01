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

class RecipeEntity: NSManagedObject {
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [RecipeEntity] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let favoriteRecipes = try? viewContext.fetch(request) else { return [] }
        return favoriteRecipes
    }
    
//    static func fetchRecipe(viewContext: NSManagedObjectContext = AppDelegate.viewContext, recipeId: String) -> RecipeEntity? {
//        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
//        request.predicate = NSPredicate(format: "id == %@", recipeId)
//        guard let favoriteRecipe = try? viewContext.fetch(request).first else { return nil }
//        return favoriteRecipe
//    }
    
    static func isRecipeRegistered(viewContext: NSManagedObjectContext = AppDelegate.viewContext, id: String) -> Bool {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let _ = try? viewContext.fetch(request).first { return true }
        return false
    }
    
    static func add(viewContext: NSManagedObjectContext = AppDelegate.viewContext, recipeDetails: RecipeDetails, ingredients: [String], image: Data?) {
        let recipe = RecipeEntity(context: viewContext)
        recipe.name = recipeDetails.name
        recipe.id = recipeDetails.id
        recipe.rating = recipeDetails.rating.likestoString()
        recipe.time = recipeDetails.totalTimeInSeconds.secondsToString()
        if let image = image {
            recipe.image = image
        }
        
        print(ingredients)
        IngredientEntity.add(viewContext: viewContext, recipe: recipe, ingredients: ingredients)
        
        try? viewContext.save()
    }
    
    static func delete(viewContext: NSManagedObjectContext = AppDelegate.viewContext, id: String) {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let recipe = try? viewContext.fetch(request).first {
            viewContext.delete(recipe)
            // Les ingrédients sont supprimés automatiquement
            //IngredientEntity.delete(viewContext: viewContext, recipe: recipe)
            try? viewContext.save()
        }
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch  {
            print("Delete all recipes - Error")
        }
    }
}

