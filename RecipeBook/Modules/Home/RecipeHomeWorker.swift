//
//  RecipeHomeWorker.swift
//  RecipeBook
//
//  Created by Hector Climaco on 11/04/23.
//  
//

import UIKit

class RecipeHomeWorker {
    private let serviceMager: ServiceMaganerProtocol
    
    public init(serviceManager: ServiceMaganerProtocol = ServicesManager()) {
        self.serviceMager = serviceManager
    }
    
    func getRecipes(page:Int, result: @escaping(Result<RecipeHome.Response, RequestError>) -> Void) {
        
        let request = RecipeHome.Request(page: page)
        guard let request = NetworkUtils.createRequest(urlStr: "/getRecipes",
                                                       method: .post,
                                                       body: request) else { return }
        self.serviceMager.fetchRequest(with: request, completion: result)
        
    }
    
}
