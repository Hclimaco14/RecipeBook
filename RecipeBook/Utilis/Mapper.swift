//
//  Mapper.swift
//
//  Created by Hector Climaco on 11/02/23.
//

import Foundation

public class Mapper<T:Codable> {
    
    public init() {}
    
    public func toJSONString(_ object: T?) -> String? {
        DispatchQueue.global().sync {
            let enconder = JSONEncoder()
            guard let obj = object else { return nil }
            guard let data = try? enconder.encode(obj) else { return nil }
            return String(data: data, encoding: String.Encoding.utf8)
        }
    }
    
    public func map(object: Any?) -> T? {
        DispatchQueue.global().sync {
            if let objectData = object as? Data {
                return map(JSONData: objectData)
            }
            
            if let objectString = object as? String {
                return map(JSONString: objectString)
            }
            
            if let objectJSON = object as? [String:Any] {
                return map(JSONObject: objectJSON)
            }
            
            return nil
        }
    }
    
    private func map(JSONData: Data?) -> T? {
        DispatchQueue.global().sync {
            
            guard let jsonData = JSONData else { return nil }
            
            var futureErrorMessage: String = ""
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode(T.self, from: jsonData)
                return object
            }
            catch let DecodingError.dataCorrupted(context) {
                futureErrorMessage = context.debugDescription
            } catch let DecodingError.keyNotFound(key, context) {
                futureErrorMessage = "Key \(key) not found: \(context.debugDescription) | codingPath: \(context.codingPath)"
            } catch let DecodingError.typeMismatch(type, context)  {
                futureErrorMessage = "Type \(type) mismatch: \(context.debugDescription) | codingPath: \(context.codingPath)"
            } catch {
                futureErrorMessage = error.localizedDescription
            }
            
            debugPrint(futureErrorMessage)
            return nil
        }
    }
    
    private func map(JSONString: String?) -> T? {
        DispatchQueue.global().sync {
            guard let jsonString = JSONString else { return nil }
            guard let JSONData = jsonString.data(using: .utf8) else { return nil }
            return map(JSONData: JSONData)
        }
    }
    
    private func map(JSONObject: [String:Any]?) -> T? {
        DispatchQueue.global().sync {
            guard let JSONObj = JSONObject else { return nil }
            guard let JSONData = JsonUtils.JSONToData(JSON: JSONObj) else { return nil }
            return map(JSONData: JSONData)
        }
    }
    
    public func mapArray(object: Any?) -> [T]? {
        DispatchQueue.global().sync {
            if let objectData = object as? Data {
                return mapArray(JSONData: objectData)
            }
            
            if let objectString = object as? String {
                return mapArray(JSONString: objectString)
            }
            
            if let objectJSON = object as? [String:Any] {
                return mapArray(JSONObject: objectJSON)
            }
            
            return nil
        }
    }
    
    private func mapArray(JSONData: Data?) -> [T]? {
        DispatchQueue.global().sync {
            
            guard let jsonData = JSONData else { return nil }
            
            var futureErrorMessage: String = ""
            do {
                let decoder = JSONDecoder()
                let object = try decoder.decode([T].self, from: jsonData)
                return object
            }
            catch let DecodingError.dataCorrupted(context) {
                futureErrorMessage = context.debugDescription
            } catch let DecodingError.keyNotFound(key, context) {
                futureErrorMessage = "Key \(key) not found: \(context.debugDescription) | codingPath: \(context.codingPath)"
            } catch let DecodingError.typeMismatch(type, context)  {
                futureErrorMessage = "Type \(type) mismatch: \(context.debugDescription) | codingPath: \(context.codingPath)"
            } catch {
                futureErrorMessage = error.localizedDescription
            }
            
            debugPrint(futureErrorMessage)
            return nil
        }
    }
    
    private func mapArray(JSONString: String?) -> [T]? {
        DispatchQueue.global().sync {
            guard let jsonString = JSONString else { return nil }
            guard let jsonData = jsonString.data(using: .utf8) else { return nil }
            return mapArray(JSONData: jsonData)
        }
    }
    
    private func mapArray(JSONObject: [String:Any]?) -> [T]? {
        DispatchQueue.global().sync {
            guard let JSONObj = JSONObject else { return nil }
            guard let jsonData = JsonUtils.JSONToData(JSON: JSONObj) else { return nil }
            return mapArray(JSONData: jsonData)
        }
    }
    
}
