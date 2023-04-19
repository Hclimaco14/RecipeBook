//
//  DetailRecipeInteractor.swift
//  RecipeBook
//
//  Created by Hector Climaco on 14/04/23.
//  
//


import Foundation


protocol DetailRecipeBusinessLogic {
    
}

class DetailRecipeInteractor:  DetailRecipeBusinessLogic {
    
    var presenter: DetailRecipePresentationLogic?
    
    let worker = DetailRecipeWorker()
    
    
    
}
