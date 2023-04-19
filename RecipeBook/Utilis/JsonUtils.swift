//
//  JsonUtils.swift
//  ClimacMovies
//
//  Created by Hector Climaco on 11/02/23.
//

import Foundation

public class JsonUtils {
    
    public class func dataToJSON(with dataInput: Data) -> [String:Any]? {
        
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: dataInput, options: .allowFragments) as? [String:Any] {
                return jsonArray // use the json here
            }
            
        } catch let error as NSError {
            debugPrint("Fail JSONSerialization: ", error)
            return nil
        }
        return nil
    }
    
    
    public class func JSONToData(JSON: [String:Any]) -> Data? {
        let jsonData = try? JSONSerialization.data(withJSONObject:JSON)
        return jsonData
    }
}
