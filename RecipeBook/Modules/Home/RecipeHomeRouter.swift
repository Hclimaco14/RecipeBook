//
//  RecipeHomeRouter.swift
//  RecipeBook
//
//  Created by Hector Climaco on 11/04/23.
//  
//


import UIKit

protocol RecipeHomeRoutingLogic {
    func routeToDetail(_ recipe: RecipeResponse)
}

class RecipeHomeRouter: RecipeHomeRoutingLogic {
    
    var view: RecipeHomeViewController?
    
    func routeToDetail(_ recipe: RecipeResponse) {
        let vc = DetailRecipeViewController()
        vc.recipe = recipe
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
