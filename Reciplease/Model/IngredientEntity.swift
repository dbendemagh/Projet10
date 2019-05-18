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
    // MARK: - CRUD
    static func fetchIngredients(viewContext: NSManagedObjectContext = AppDelegate.viewContext, recipe: RecipeEntity) -> [IngredientEntity] {
        let request: NSFetchRequest<IngredientEntity> = IngredientEntity.fetchRequest()
        request.predicate = NSPredicate(format: "recipe == %@", recipe)
        request.sortDescriptors = [NSSortDescriptor(key: "displayOrder", ascending: true)]
        guard let ingredients = try? viewContext.fetch(request) else { return [] }
        return ingredients
    }
    
    static func add(viewContext: NSManagedObjectContext = AppDelegate.viewContext, recipe: RecipeEntity, ingredients: [String]) {
        for index in 0...ingredients.count - 1 {
            let ingredient = IngredientEntity(context: viewContext)
            ingredient.name = ingredients[index]
            ingredient.displayOrder = Int32(index)
            ingredient.recipe = recipe
        }
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "IngredientEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        let _ = try? viewContext.execute(deleteRequest)
        try? viewContext.save()
    }
}
