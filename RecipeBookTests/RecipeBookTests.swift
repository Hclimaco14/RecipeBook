//
//  RecipeBookTests.swift
//  RecipeBookTests
//
//  Created by Hector Climaco on 11/04/23.
//

import XCTest
@testable import RecipeBook

final class RecipeBookTests: XCTestCase {
    let servieManager = ServicesManager()
    let recipeHomeWorker = RecipeHomeWorker()
    let timeoutExpectation:TimeInterval =  60

    func testGetSession() {
        let expectation = self.expectation(description: "waitingRespons")
        
        recipeHomeWorker.getRecipes(page: 1) { result in
            switch result {
            case .success(let response):
                print(response)
                if response.success ?? false {
                    XCTAssert(true,"Success testGetSession")
                } else {
                    XCTAssert(false,"Failure testGetSession")
                }
                expectation.fulfill()
                
            case .failure(let error):
                XCTAssert(false,"Failure testGetSession \(error)")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: timeoutExpectation, handler: nil)
    }
}
