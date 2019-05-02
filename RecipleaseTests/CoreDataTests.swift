//
//  CoreDataTests.swift
//  RecipleaseTests
//
//  Created by Daniel BENDEMAGH on 27/04/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import XCTest
import CoreData
@testable import Reciplease

class CoreDataTests: XCTestCase {
    let fakeDataRecipe = FakeData(file: File.recipes, fileExt: "json")
    let fakeDataRecipeDetails = FakeData(file: File.recipeDetails, fileExt: "json")
    let fakeDataImage = FakeData(file: File.defaultImage, fileExt: "png")
    let id = "Crispy-Sesame-Chicken-With-a-Sticky-Asian-Sauce-2597971"
    
    var fakeRecipes: Recipes?
    var fakeRecipeDetails: RecipeDetails?
    var fakeRecipeEntity: RecipeEntity?
    
    lazy var mockContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Reciplease")
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: { (description, error) in
            XCTAssertNil(error)
        })
        return container
    }()
    
    override func setUp() {
        fakeRecipes = try? JSONDecoder().decode(Recipes.self, from: fakeDataRecipe.correctData)
        fakeRecipeDetails = try? JSONDecoder().decode(RecipeDetails.self, from: fakeDataRecipeDetails.correctData)
        
        guard let fakeRecipes = fakeRecipes, let fakeRecipeDetails = fakeRecipeDetails else {
            XCTFail("JSON Decode error")
            return
        }
        
        let recipe = fakeRecipes.matches[0]
        RecipeEntity.add(viewContext: mockContainer.viewContext, recipeDetails: fakeRecipeDetails, ingredients: recipe.ingredients, image: fakeDataImage.correctData)
    }

    override func tearDown() {
        RecipeEntity.deleteAll(viewContext: mockContainer.viewContext)
        IngredientEntity.deleteAll(viewContext: mockContainer.viewContext)
        
        super.tearDown()
    }

    func testAddRecipe() {
        let recipes = RecipeEntity.fetchAll(viewContext: mockContainer.viewContext)
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes[0].name, "Crispy Sesame Chicken With a Sticky Asian Sauce")
        XCTAssertEqual(recipes[0].id, id)
        guard let image = recipes[0].image else {
            XCTFail("No image")
            return
        }
        XCTAssertTrue(image.isImage())
        
        let ingredients = IngredientEntity.fetchIngredients(viewContext: mockContainer.viewContext, recipe: recipes[0])
        XCTAssertEqual(ingredients.count, 20)
        XCTAssertEqual(ingredients[0].name, "olive oil")
        XCTAssertEqual(ingredients[1].name, "eggs")
        
        let ingredientsDetail = IngredientDetailEntity.fetchIngredientsDetail(viewContext: mockContainer.viewContext, recipe: recipes[0])
        //let ingredients = IngredientDetailEntity.fe fetchIngredients(viewContext: mockContainer.viewContext, recipe: recipes[0])
        XCTAssertEqual(ingredientsDetail.count, 20)
        XCTAssertEqual(ingredientsDetail[0].dosage, "5 tbsp olive oil")
        XCTAssertEqual(ingredientsDetail[1].dosage, "2 eggs lightly beaten")
    }
    
    func testIsRegistered() {
        let registered = RecipeEntity.isRecipeRegistered(viewContext: mockContainer.viewContext, id: id)
        XCTAssertTrue(registered)
    }
    
    func testDeleteRecipe() {
        var recipes = RecipeEntity.fetchAll(viewContext: mockContainer.viewContext)
        XCTAssertEqual(recipes.count, 1)
        let recipe = recipes[0]
        var ingredients = IngredientEntity.fetchIngredients(viewContext: mockContainer.viewContext, recipe: recipe)
        XCTAssertEqual(ingredients.count, 20)
        var ingredientsDetail = IngredientDetailEntity.fetchIngredientsDetail(viewContext: mockContainer.viewContext, recipe: recipe)
        XCTAssertEqual(ingredients.count, 20)
        
        RecipeEntity.delete(viewContext: mockContainer.viewContext, id: recipes[0].id!)
        
        recipes = RecipeEntity.fetchAll(viewContext: mockContainer.viewContext)
        XCTAssertEqual(recipes.count, 0)
        ingredients = IngredientEntity.fetchIngredients(viewContext: mockContainer.viewContext, recipe: recipe)
        XCTAssertEqual(ingredients.count, 0)
        ingredientsDetail = IngredientDetailEntity.fetchIngredientsDetail(viewContext: mockContainer.viewContext, recipe: recipe)
        XCTAssertEqual(ingredientsDetail.count, 0)
        
    }
}
