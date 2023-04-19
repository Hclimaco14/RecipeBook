//
//  DetailRecipeModels.swift
//  RecipeBook
//
//  Created by Hector Climaco on 14/04/23.
//  
//

import UIKit
import MapKit

enum DetailRecipe {
    
    struct ViewModel {
        var imageDetail: String
        var titleRecipe: String
        var descriptionRecipe: String
        var ingredients: String
        var location:CLLocationCoordinate2D
        var adress: String
        
        init() {
            let recipe = RecipeResponse()
            self.imageDetail = recipe.image
            self.titleRecipe = recipe.name
            self.descriptionRecipe = recipe.description
            self.ingredients = recipe.ingredients.joined(separator: "\n*")
            self.location = CLLocationCoordinate2D()
            self.adress = ""
        }
        
        init(recipe: RecipeResponse) {
            self.imageDetail = recipe.image
            self.titleRecipe = recipe.name
            self.descriptionRecipe = recipe.description
            self.ingredients = recipe.ingredients.joined(separator: "\n*")
            self.location = CLLocationCoordinate2D(latitude: recipe.location.latitude, longitude: recipe.location.longitude)
            self.adress = recipe.adress
        }
        
        
    }
    
}
