//
//  RecipeHomeModels.swift
//  RecipeBook
//
//  Created by Hector Climaco on 11/04/23.
//  
//

import UIKit

typealias RecipeResponse = RecipeHome.Response.Recipe

public enum RecipeHome {
    
    struct Request:Codable {
        var page:Int
    }
    
    struct Response:Codable {
        
        var success: Bool
        var recipes: [Recipe]
        
        struct Recipe:Codable {
            var id: String
            var name: String
            var shortDescription: String
            var description: String
            var image: String
            var ingredients: [String]
            var location: Location
            var adress: String
            
            internal init(id:String = "",name: String, shortDescription: String, description: String, image: String, ingredients: [String], location: RecipeHome.Response.Location, adress:String) {
                self.id = id
                self.name = name
                self.shortDescription = shortDescription
                self.description = description
                self.image = image
                self.ingredients = ingredients
                self.location = location
                self.adress = adress
            }
            
            init() {
                self.id = ""
                self.name = ""
                self.description = ""
                self.shortDescription = ""
                self.image = ""
                self.ingredients = []
                self.location = Location()
                self.adress = ""
            }
        }
        
        struct Location:Codable{
            var latitude: Double
            var longitude: Double
            
            internal init(latitude: Double, longitude: Double) {
                self.latitude = latitude
                self.longitude = longitude
            }
            
            
            init() {
                self.latitude = 0
                self.longitude = 0
            }
        }
    }
    
    struct ViewModel {
        var recipeName: String
        var recipDescription:String
        var imageURL: String
        
        init() {
            self.recipeName = ""
            self.recipDescription = ""
            self.imageURL = ""
        }
        
        init(recipe: RecipeResponse) {
            self.recipeName = recipe.name
            self.recipDescription = recipe.shortDescription
            self.imageURL = recipe.image
        }
    }
    
    
}
