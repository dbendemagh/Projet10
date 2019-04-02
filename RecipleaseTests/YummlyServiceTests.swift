//
//  YummlyServiceTests.swift
//  RecipleaseTests
//
//  Created by Daniel BENDEMAGH on 03/03/2019.
//  Copyright © 2019 Daniel BENDEMAGH. All rights reserved.
//

import XCTest
@testable import Reciplease

class YummlyServiceTests: XCTestCase {
    
    let ingredients = ["cake", "chocolate", "cherry"]
    
    // MARK: - Search recipes tests
    
    func testSearchRecipesShouldPostFailedCallback() {
        let fakeResponse = FakeResponse(response: nil, data: nil, error: FakeNetworkResponse.networkError)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.searchRecipes(ingredients: ingredients) { (success, recipes) in
            XCTAssertFalse(success)
            XCTAssertNil(recipes)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchRecipesShouldPostFailedCallbackIfNoData() {
        let fakeResponse = FakeResponse(response: nil, data: FakeNetworkResponse.incorrectData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.searchRecipes(ingredients: ingredients) { (success, recipes) in
            XCTAssertFalse(success)
            XCTAssertNil(recipes)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchRecipesShouldPostFailedCallbackIfIncorrectResponse() {
        let fakeJsonResponse = FakeJsonResponse(jsonFile: "Recipes")
        let fakeResponse = FakeResponse(response: FakeNetworkResponse.responseKO, data: fakeJsonResponse.correctData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.searchRecipes(ingredients: ingredients) { (success, recipes) in
            XCTAssertFalse(success)
            XCTAssertNil(recipes)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testSearchRecipesShouldPostFailedCallbackIfResponseCorrectAndNilData() {
        let fakeResponse = FakeResponse(response: FakeNetworkResponse.responseOK, data: nil, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.searchRecipes(ingredients: ingredients) { (success, recipes) in
            XCTAssertFalse(success)
            XCTAssertNil(recipes)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchRecipesShouldPostFailedCallbackIfIncorrectData() {
        let fakeResponse = FakeResponse(response: FakeNetworkResponse.responseOK, data: FakeNetworkResponse.incorrectData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.searchRecipes(ingredients: ingredients) { (success, recipes) in
            XCTAssertFalse(success)
            XCTAssertNil(recipes)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchRecipesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeJsonResponse = FakeJsonResponse(jsonFile: "Recipes")
        let fakeResponse = FakeResponse(response: FakeNetworkResponse.responseOK, data: fakeJsonResponse.correctData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.searchRecipes(ingredients: ingredients) { (success, recipes) in
            XCTAssertTrue(success)
            XCTAssertNotNil(recipes)
            XCTAssertEqual(recipes!.matches[0].sourceDisplayName, "Tatyanas Everyday Food")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - Recipe details tests
    
    func testGetRecipeDetailsShouldPostFailedCallback() {
        let fakeResponse = FakeResponse(response: nil, data: nil, error: FakeNetworkResponse.networkError)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.getRecipeDetails(recipeId: "Meatball-Parmesan-Casserole-2626493") { (success, recipeDetails) in
            XCTAssertFalse(success)
            XCTAssertNil(recipeDetails)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeDetailsShouldPostFailedCallbackIfResponseCorrectAndNilData() {
        let fakeResponse = FakeResponse(response: FakeNetworkResponse.responseOK, data: nil, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.getRecipeDetails(recipeId: "Meatball-Parmesan-Casserole-2626493") { (success, recipeDetails) in
            XCTAssertFalse(success)
            XCTAssertNil(recipeDetails)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeDetailsShouldPostFailedCallbackIfIncorrectData() {
        let fakeResponse = FakeResponse(response: FakeNetworkResponse.responseOK, data: FakeNetworkResponse.incorrectData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.getRecipeDetails(recipeId: "Meatball-Parmesan-Casserole-2626493") { (success, recipeDetails) in
            XCTAssertFalse(success)
            XCTAssertNil(recipeDetails)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRecipeDetailsShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeJsonResponse = FakeJsonResponse(jsonFile: "YummlyRecipeDetails")
        let fakeResponse = FakeResponse(response: FakeNetworkResponse.responseOK, data: fakeJsonResponse.correctData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.getRecipeDetails(recipeId: "Meatball-Parmesan-Casserole-2626493") { (success, recipeDetails) in
            XCTAssertTrue(success)
            XCTAssertNotNil(recipeDetails)
            XCTAssertEqual(recipeDetails!.ingredientLines[0], "1 bag of frozen meatballs, cooked according to package directions")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}


