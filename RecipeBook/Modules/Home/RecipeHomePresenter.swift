//
//  RecipeHomePresenter.swift
//  RecipeBook
//
//  Created by Hector Climaco on 11/04/23.
//  
//

import UIKit

protocol RecipeHomePresentationLogic {
    func presentRecipes(recipesResponse: [RecipeResponse])
}

class RecipeHomePresenter: RecipeHomePresentationLogic {
    
    var view: RecipeHomeDisplayLogic?
    
    func presentRecipes(recipesResponse: [RecipeResponse]) {
        view?.displayRecipes(recipes: recipesResponse)
    }
}
