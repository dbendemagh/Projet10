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
    let fakeDataImage = FakeData(file: File.defaultImage, fileExt: "jpg")
    let recipeId = "Crispy-Sesame-Chicken-With-a-Sticky-Asian-Sauce-2597971"
    
    var fakeRecipes: YummlyRecipes?
    var fakeRecipeDetails: YummlyRecipeDetails?
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
        guard let fakeRecipeJSON = fakeDataRecipe.correctData, let fakeRecipeDetailsJSON = fakeDataRecipeDetails.correctData else {
            XCTFail("Load data error")
            return
        }
        
        fakeRecipes = try? JSONDecoder().decode(YummlyRecipes.self, from: fakeRecipeJSON)
        fakeRecipeDetails = try? JSONDecoder().decode(YummlyRecipeDetails.self, from: fakeRecipeDetailsJSON)
        
        guard let fakeRecipes = fakeRecipes, let fakeRecipeDetails = fakeRecipeDetails else {
            XCTFail("JSON Decode error")
            return
        }
        
        let recipe = fakeRecipes.matches[0]
        let recipeDetails = RecipeDetails(name: recipe.recipeName,
                                          id: recipe.id,
                                          time: recipe.totalTimeInSeconds.secondsToString(),
                                          rating: recipe.rating.secondsToString(),
                                          urlImage: "",
                                          image: fakeDataImage.correctData,
                                          ingredients: recipe.ingredients,
                                          ingredientsDetail: fakeRecipeDetails.ingredientLines,
                                          urlDirections: fakeRecipeDetails.source.sourceRecipeUrl,
                                          shoppingList: false)
        
        RecipeEntity.add(viewContext: mockContainer.viewContext, recipeDetails: recipeDetails)
    }

    override func tearDown() {
        RecipeEntity.deleteAll(viewContext: mockContainer.viewContext)
        IngredientEntity.deleteAll(viewContext: mockContainer.viewContext)
        IngredientDetailEntity.deleteAll(viewContext: mockContainer.viewContext)
        super.tearDown()
    }

    func testAddRecipe() {
        let recipes = RecipeEntity.fetchAll(viewContext: mockContainer.viewContext)
        XCTAssertEqual(recipes.count, 1)
        XCTAssertEqual(recipes[0].name, "Crispy Sesame Chicken With a Sticky Asian Sauce")
        XCTAssertEqual(recipes[0].id, recipeId)
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
        let isRegistered = RecipeEntity.isRecipeRegistered(viewContext: mockContainer.viewContext, id: recipeId)
        XCTAssertTrue(isRegistered)
    }
    
    func testSearchRecipe() {
        let recipes = RecipeEntity.searchRecipes(searchText: "sEsAmE")
        XCTAssertEqual(recipes[0].name, "Crispy Sesame Chicken With a Sticky Asian Sauce")
    }
    
    func testToggleShoppingList() {
        var recipes = RecipeEntity.fetchAll(viewContext: mockContainer.viewContext)
        XCTAssertEqual(recipes[0].shoppingList, false)
        if let id = recipes[0].id {
            RecipeEntity.toggleShoppingList(viewContext: mockContainer.viewContext, id: id)
        }
        recipes = RecipeEntity.fetchAll(viewContext: mockContainer.viewContext)
        XCTAssertEqual(recipes[0].shoppingList, true)
    }
    
    func testFetchRecipesInShoppingList() {
        RecipeEntity.toggleShoppingList(viewContext: mockContainer.viewContext, id: recipeId)
        let recipesInShoppingList = RecipeEntity.fetchRecipesInShoppingList(viewContext: mockContainer.viewContext)
        XCTAssertEqual(recipesInShoppingList.count, 1)
        XCTAssertEqual(recipesInShoppingList[0].name, "Crispy Sesame Chicken With a Sticky Asian Sauce")
    }
    
    func testIsInShoppingList() {
        RecipeEntity.toggleShoppingList(viewContext: mockContainer.viewContext, id: recipeId)
        let isInShoppingList = RecipeEntity.isInShoppingList(viewContext: mockContainer.viewContext, id: recipeId)
        XCTAssertEqual(isInShoppingList, true)
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
    
    func testFetchIngredientsInShoppingList() {
        RecipeEntity.toggleShoppingList(viewContext: mockContainer.viewContext, id: recipeId)
        let ingredientsDetail = IngredientDetailEntity.fetchIngredientsInShoppingList(viewContext: mockContainer.viewContext)
        XCTAssertEqual(ingredientsDetail.count, 20)
        XCTAssertEqual(ingredientsDetail[0].dosage, "5 tbsp olive oil")
        XCTAssertEqual(ingredientsDetail[1].dosage, "2 eggs lightly beaten")
    }
    
    func testSetPurchased() {
        RecipeEntity.toggleShoppingList(viewContext: mockContainer.viewContext, id: recipeId)
        let ingredientsDetail = IngredientDetailEntity.fetchIngredientsInShoppingList(viewContext: mockContainer.viewContext)
        XCTAssertEqual(ingredientsDetail[0].purchased, false)
        IngredientDetailEntity.setPurchased(viewContext: mockContainer.viewContext, ingredient: ingredientsDetail[0], isPurchased: true)
        XCTAssertEqual(ingredientsDetail[0].purchased, true)
    }
}
