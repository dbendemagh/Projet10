//
//  IngredientPreparationEntity.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 01/05/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation
import CoreData

class IngredientDetailEntity: NSManagedObject {
    // MARK: - CRUD
    static func fetchIngredientsDetail(viewContext: NSManagedObjectContext = AppDelegate.viewContext, recipe: RecipeEntity) -> [IngredientDetailEntity] {
        let request: NSFetchRequest<IngredientDetailEntity> = IngredientDetailEntity.fetchRequest()
        request.predicate = NSPredicate(format: "recipe == %@", recipe)
        request.sortDescriptors = [NSSortDescriptor(key: "displayOrder", ascending: true)]
        guard let ingredientsDetail = try? viewContext.fetch(request) else { return [] }
        return ingredientsDetail
    }
    
    static func add(viewContext: NSManagedObjectContext = AppDelegate.viewContext, recipe: RecipeEntity, ingredientsDetail: [String]) {
        //for currentIngredientDetail in ingredientsDetail {
        for index in 0...ingredientsDetail.count - 1 {
            let ingredientDetail = IngredientDetailEntity(context: viewContext)
            ingredientDetail.dosage = ingredientsDetail[index]
            ingredientDetail.displayOrder = Int32(index)
            ingredientDetail.recipe = recipe
        }
    }
    
    static func deleteAll(viewContext: NSManagedObjectContext = AppDelegate.viewContext) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "IngredientDetailEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        let _ = try? viewContext.execute(deleteRequest)
        try? viewContext.save()
    }
    
    // MARK: - Shopping List
    static func fetchIngredientsInShoppingList(viewContext: NSManagedObjectContext = AppDelegate.viewContext)-> [IngredientDetailEntity] {
        let recipes = RecipeEntity.fetchRecipesInShoppingList(viewContext: viewContext)
        
        let request: NSFetchRequest<IngredientDetailEntity> = IngredientDetailEntity.fetchRequest()
        request.predicate = NSPredicate(format: "recipe IN %@", recipes)
        request.sortDescriptors = [NSSortDescriptor(key: "displayOrder", ascending: true)]
        guard let ingredientsDetail = try? viewContext.fetch(request) else { return [] }
        return ingredientsDetail
        //        for recipe in recipes {
        //            let request: NSFetchRequest<IngredientDetailEntity> = IngredientDetailEntity.fetchRequest()
        //            request.predicate = NSPredicate(format: "recipe == %@", recipe)
        //            request.sortDescriptors = [NSSortDescriptor(key: "displayOrder", ascending: true)]
        //            let ingredientsDetail = try? viewContext.fetch(request)
        //
        //        }
        
    }
}
