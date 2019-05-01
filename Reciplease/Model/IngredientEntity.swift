//
//  Ingredient.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 02/04/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

import CoreData

class IngredientEntity: NSManagedObject {
    static func fetchIngredients(viewContext: NSManagedObjectContext = AppDelegate.viewContext, recipe: RecipeEntity) -> [IngredientEntity] {
        let request: NSFetchRequest<IngredientEntity> = IngredientEntity.fetchRequest()
        request.predicate = NSPredicate(format: "recipe == %@", recipe)
        guard let ingredients = try? viewContext.fetch(request) else { return [] }
        return ingredients
    }
    
    static func add(viewContext: NSManagedObjectContext = AppDelegate.viewContext, recipe: RecipeEntity, ingredients: [String]) {
        
        for currentIngredient in ingredients {
            let ingredient = IngredientEntity(context: viewContext)
            ingredient.name = currentIngredient
            ingredient.recipe = recipe
        }
    }
    
    // Cascade activé ok
    static func delete(viewContext: NSManagedObjectContext = AppDelegate.viewContext, recipe: RecipeEntity) {
        let request: NSFetchRequest<IngredientEntity> = IngredientEntity.fetchRequest()
        request.predicate = NSPredicate(format: "recipe == %@", recipe)
        
        
        if let ingredients = try? viewContext.fetch(request) {
            for ingredient in ingredients {
                viewContext.delete(ingredient)
            }
            
            try? viewContext.save()
        }
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "IngredientEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch  {
            print("Delete all ingredients - Error")
        }
    }}
