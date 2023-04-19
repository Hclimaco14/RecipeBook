//
//  MapInteractor.swift
//  RecipeBook
//
//  Created by Hector Climaco on 16/04/23.
//  
//


import Foundation


protocol MapBusinessLogic {
    
}

class MapInteractor:  MapBusinessLogic {
    
    var presenter: MapPresentationLogic?
    
    let worker = MapWorker()
    
    
    
}
