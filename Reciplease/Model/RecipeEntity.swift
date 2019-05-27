//
//  FavoriteRecipe.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 02/04/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
import CoreData

class RecipeEntity: NSManagedObject {
    // MARK: - CRUD
    static func fetchAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [RecipeEntity] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let favoriteRecipes = try? viewContext.fetch(request) else { return [] }
        return favoriteRecipes
    }
    
    static func add(viewContext: NSManagedObjectContext = AppDelegate.viewContext, recipeDetails: RecipeDetails) { //}, ingredients: [String]) { //}, image: Data?) {
        let recipe = RecipeEntity(context: viewContext)
        recipe.name = recipeDetails.name
        recipe.id = recipeDetails.id
        recipe.rating = recipeDetails.rating
        recipe.time = recipeDetails.time
        recipe.urlDirections = recipeDetails.urlDirections
        recipe.shoppingList = recipeDetails.shoppingList
        if let image = recipeDetails.image {
            recipe.image = image
        }
        
        IngredientEntity.add(viewContext: viewContext, recipe: recipe, ingredients: recipeDetails.ingredients)
        IngredientDetailEntity.add(viewContext: viewContext, recipe: recipe, ingredientsDetail: recipeDetails.ingredientsDetail)
        try? viewContext.save()
    }
    
    static func delete(viewContext: NSManagedObjectContext = AppDelegate.viewContext, id: String) {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let recipe = try? viewContext.fetch(request).first {
            viewContext.delete(recipe)
            
            try? viewContext.save()
        }
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        let _ = try? viewContext.execute(deleteRequest)
        try? viewContext.save()
    }
    
    // MARK: - Functions
    static func searchRecipes(viewContext: NSManagedObjectContext = AppDelegate.viewContext, searchText: String) -> [RecipeEntity] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
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
    
    // MARK: - Shopping List
    
    static func fetchRecipesInShoppingList(viewContext: NSManagedObjectContext = AppDelegate.viewContext) -> [RecipeEntity] {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "shoppingList == True")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let favoriteRecipes = try? viewContext.fetch(request) else { return [] }
        return favoriteRecipes
    }
    
    static func isInShoppingList(viewContext: NSManagedObjectContext = AppDelegate.viewContext, id: String) -> Bool {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND shoppingList == True", id)
        if let _ = try? viewContext.fetch(request).first { return true }
        return false
    }
    
    static func toggleShoppingList(viewContext: NSManagedObjectContext = AppDelegate.viewContext, id: String) {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let recipe = try? viewContext.fetch(request).first {
            recipe.shoppingList.toggle()
            try? viewContext.save()
        }
    }
}

