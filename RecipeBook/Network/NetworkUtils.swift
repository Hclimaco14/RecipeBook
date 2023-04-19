//
//  NetworkUtils.swift
//
//  Created by Hector Climaco on 24/03/23.
//

import Foundation


class NetworkUtils {
    
    public static func createRequest(urlStr: String, method: HTTPMethod, body: Codable? = nil) -> URLRequest?{
        
        var urlString = NetworkConstant.domain
        urlString += urlStr
        

        guard let urlConexion = URL(string: urlString) else { return nil }
        
        var urlRequest = URLRequest(url: urlConexion)
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = NetworkConstant.timeOutInterval
        urlRequest.allHTTPHeaderFields = NetworkConstant.headers
        if let dataBody = body?.toData() {
            urlRequest.httpBody =  dataBody
        }
        
        return urlRequest
        
    }
}


struct NetworkConstant {
    public static let timeOutInterval: Double = 60
    public static let domain: String = "https://demo8512223.mockable.io"
    
    public static var headers: [String:String] = [
        "Content-Type":"application/json"
    ]
}
