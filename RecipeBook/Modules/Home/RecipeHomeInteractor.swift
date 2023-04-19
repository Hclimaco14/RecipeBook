//
//  RecipeHomeInteractor.swift
//  RecipeBook
//
//  Created by Hector Climaco on 11/04/23.
//  
//


import Foundation


protocol RecipeHomeBusinessLogic {
    func getRecipes(page: Int)
}

class RecipeHomeInteractor:  RecipeHomeBusinessLogic {
    
    var presenter: RecipeHomePresentationLogic?
    
    let worker = RecipeHomeWorker()
  
    func getRecipes(page: Int) {
    
        worker.getRecipes(page: page) { result in
            switch result {
            case .success(let response):
                if response.success {
                    self.presenter?.presentRecipes(recipesResponse: response.recipes)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
