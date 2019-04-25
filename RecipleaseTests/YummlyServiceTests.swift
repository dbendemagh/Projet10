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
    let recipeId = "Meatball-Parmesan-Casserole-2626493"
    let urlImage = URL(string: "https://images.com/test")!
    
    // MARK: - Search recipes tests
    
    func testSearchRecipesShouldPostFailedCallbackIfError() {
        let fakeResponse = FakeResponse(httpResponse: nil, data: nil, error: FakeNetworkResponse.networkError)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        yummlyService.searchRecipes(ingredients: ingredients) { result in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchRecipesShouldPostFailedCallbackIfIncorrectURL() {
        let fakeResponse = FakeResponse(httpResponse: nil, data: nil, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.searchRecipes(ingredients: ["Error in ingredients"]) { result in
            guard case .failure(NetworkError.incorrectURL) = result else {
                XCTFail()
                return
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchRecipesShouldPostFailedCallbackIfIncorrectResponse() {
        let fakeDataRecepted = FakeDataRecepted(file: "Recipes", fileExt: "json")
        let fakeResponse = FakeResponse(httpResponse: FakeNetworkResponse.responseKO, data: fakeDataRecepted.correctData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        yummlyService.searchRecipes(ingredients: ingredients) { result in
            guard case .failure(NetworkError.httpResponseKO) = result else {
                XCTFail()
                return
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testSearchRecipesShouldPostFailedCallbackIfIncorrectData() {
        let fakeResponse = FakeResponse(httpResponse: FakeNetworkResponse.responseOK, data: FakeNetworkResponse.incorrectData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.searchRecipes(ingredients: ingredients) { result in
            guard case .failure(NetworkError.jsonDecodeError) = result else {
                XCTFail()
                return
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSearchRecipesShouldPostFailedCallbackIfResponseCorrectAndNilData() {
        let fakeResponse = FakeResponse(httpResponse: FakeNetworkResponse.responseOK, data: nil, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        yummlyService.searchRecipes(ingredients: ingredients) { result in
            guard case .failure(NetworkError.noData) = result else {
                XCTFail()
                return
            }
            //XCTAssertNotNil(error as? NetworkError)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testSearchRecipesShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeDataRecepted = FakeDataRecepted(file: "Recipes", fileExt: "json")
        let fakeResponse = FakeResponse(httpResponse: FakeNetworkResponse.responseOK, data: fakeDataRecepted.correctData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        yummlyService.searchRecipes(ingredients: ingredients) { result in
            guard case .success(let recipes) = result else {
                XCTFail()
                return
            }
            XCTAssertEqual(recipes.matches[0].sourceDisplayName, "Tatyanas Everyday Food")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    // MARK: - Recipe details tests

    func testGetRecipeDetailsShouldPostFailedCallbackIfError() {
        let fakeResponse = FakeResponse(httpResponse: nil, data: nil, error: FakeNetworkResponse.networkError)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        yummlyService.getRecipeDetails(recipeId: recipeId) { result in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testRecipeDetailsShouldPostFailedCallbackIfIncorrectURL() {
        let fakeResponse = FakeResponse(httpResponse: nil, data: nil, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.getRecipeDetails(recipeId: "Error in recipe Id") { result in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testRecipeDetailsShouldPostFailedCallbackIfIncorrectResponse() {
        let fakeDataRecepted = FakeDataRecepted(file: "RecipeDetails", fileExt: "json")
        let fakeResponse = FakeResponse(httpResponse: FakeNetworkResponse.responseKO, data: fakeDataRecepted.correctData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.getRecipeDetails(recipeId: recipeId) { result in
            guard case .failure(NetworkError.httpResponseKO) = result else {
                XCTFail()
                return
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRecipeDetailsShouldPostFailedCallbackIfIncorrectData() {
        let fakeResponse = FakeResponse(httpResponse: FakeNetworkResponse.responseOK, data: FakeNetworkResponse.incorrectData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        yummlyService.getRecipeDetails(recipeId: recipeId) { result in
            guard case .failure(NetworkError.jsonDecodeError) = result else {
                XCTFail()
                return
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }

    func testGetRecipeDetailsShouldPostFailedCallbackIfResponseCorrectAndNilData() {
        let fakeResponse = FakeResponse(httpResponse: FakeNetworkResponse.responseOK, data: nil, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.getRecipeDetails(recipeId: recipeId) { result in
            guard case .failure(NetworkError.noData) = result else {
                XCTFail()
                return
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    func testGetRecipeDetailsShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeDataRecepted = FakeDataRecepted(file: "RecipeDetails", fileExt: "json")
        let fakeResponse = FakeResponse(httpResponse: FakeNetworkResponse.responseOK, data: fakeDataRecepted.correctData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)

        let expectation = XCTestExpectation(description: "Wait for queue change.")

        yummlyService.getRecipeDetails(recipeId: recipeId) { result in
            guard case .success(let recipeDetails) = result else {
                XCTFail()
                return
            }
            XCTAssertEqual(recipeDetails.ingredientLines[0], "1 bag of frozen meatballs, cooked according to package directions")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: - Get image tests
    
    func testGetImageShouldPostFailedCallbackIfError() {
        let fakeResponse = FakeResponse(httpResponse: nil, data: nil, error: FakeNetworkResponse.networkError)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.getImage(url: urlImage) { result in
            guard case .failure(_) = result else {
                XCTFail()
                return
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetImageShouldPostFailedCallbackIfIncorrectResponse() {
        let fakeDataRecepted = FakeDataRecepted(file: "Recipes", fileExt: "json")
        let fakeResponse = FakeResponse(httpResponse: FakeNetworkResponse.responseKO, data: fakeDataRecepted.correctData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.getImage(url: urlImage) { result in
            guard case .failure(NetworkError.httpResponseKO) = result else {
                XCTFail()
                return
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetImageShouldPostFailedCallbackIfIncorrectData() {
        let fakeResponse = FakeResponse(httpResponse: FakeNetworkResponse.responseOK, data: FakeNetworkResponse.incorrectData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.getImage(url: urlImage) { result in
            guard case .failure(NetworkError.incorrectData) = result else {
                XCTFail()
                return
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetImageShouldPostFailedCallbackIfResponseCorrectAndNilData() {
        let fakeResponse = FakeResponse(httpResponse: FakeNetworkResponse.responseOK, data: nil, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.getImage(url: urlImage) { result in
            guard case .failure(NetworkError.noData) = result else {
                XCTFail()
                return
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetImageShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeDataRecepted = FakeDataRecepted(file: "Ingredients", fileExt: "png")
        let fakeResponse = FakeResponse(httpResponse: FakeNetworkResponse.responseOK, data: fakeDataRecepted.correctData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.getImage(url: urlImage) { result in
            guard case .success(_) = result else {
                XCTFail()
                return
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}


