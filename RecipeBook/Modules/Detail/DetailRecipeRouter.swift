//
//  DetailRecipeRouter.swift
//  RecipeBook
//
//  Created by Hector Climaco on 14/04/23.
//  
//


import UIKit

protocol DetailRecipeRoutingLogic {
    func goToMap(recipe: RecipeResponse)
}

class DetailRecipeRouter: DetailRecipeRoutingLogic {
    
    var view: DetailRecipeViewController?
    
    func goToMap(recipe: RecipeResponse) {
        let vc = MapViewController()
        vc.recipe = recipe
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
