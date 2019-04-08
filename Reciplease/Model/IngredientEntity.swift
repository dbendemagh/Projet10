//
//  Ingredient.swift
//  Reciplease
//
//  Created by Daniel BENDEMAGH on 02/04/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import Foundation

import CoreData

class IngredientEntity : NSManagedObject {
    static func add(viewContext: NSManagedObjectContext = AppDelegate.viewContext, recipe: RecipeEntity, ingredients: [String]) {
        
        for currentIngredient in ingredients {
            let ingredient = IngredientEntity(context: viewContext)
            ingredient.name = currentIngredient
            ingredient.recipe = recipe
            
        }
        
    }
}
