//
//  MapModels.swift
//  RecipeBook
//
//  Created by Hector Climaco on 16/04/23.
//  
//

import UIKit
import MapKit

typealias RecipeAnnotation = Map.Recipe

enum Map {
    
    class Recipe: NSObject, MKAnnotation {
        var title: String?
        var coordinate: CLLocationCoordinate2D
        var info: String

        override init() {
            self.title = ""
            self.coordinate = CLLocationCoordinate2D()
            self.info = ""
        }
        
        init(title: String, info: String, coordinate: CLLocationCoordinate2D) {
            self.title = title
            self.coordinate = coordinate
            self.info = info
        }
    }
    
    struct ViewModel {
        var id: String
        var location: CLLocationCoordinate2D
        var annotation: RecipeAnnotation
        
        init() {
            self.id = ""
            self.location = CLLocationCoordinate2D()
            self.annotation = RecipeAnnotation()
        }
        
        init(recipe: RecipeResponse) {
            self.id = recipe.id
            
            self.location = CLLocationCoordinate2D(latitude: recipe.location.latitude,
                                                   longitude: recipe.location.longitude)
            let annotation = RecipeAnnotation(title: recipe.name, info: recipe.shortDescription,
                                              coordinate: self.location)
            self.annotation = annotation
        }
    }
    
}
