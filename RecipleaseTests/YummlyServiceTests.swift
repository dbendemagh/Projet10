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

    func testSearchRecipesShouldPostFailedCallback() {
        let fakeResponse = FakeResponse(response: nil, data: nil, error: FakeResponseData.networkError)
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
        let fakeResponse = FakeResponse(response: nil, data: FakeResponseData.incorrectData, error: nil)
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
        let fakeResponse = FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctData, error: nil)
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
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: nil, error: nil)
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
    
    func testGetExchangeRateShouldPostFailedCallbackIfIncorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData, error: nil)
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
    
    func testGetExchangeRateShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        let fakeResponse = FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctData, error: nil)
        let yummlySessionFake = YummlySessionFake(fakeResponse: fakeResponse)
        let yummlyService = YummlyService(yummlySession: yummlySessionFake)
        
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        
        yummlyService.searchRecipes(ingredients: ingredients) { (success, recipes) in
            XCTAssertTrue(success)
            XCTAssertNotNil(recipes)
            XCTAssertEqual(recipes![0].sourceDisplayName, "Tatyanas Everyday Food")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}


