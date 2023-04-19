//
//  ServiceManager.swift
//
//  Created by Hector Climaco on 24/03/23.
//

import Foundation

public enum HTTPMethod:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

public class RequestError: Codable,Error {
    var success: Bool?
    var statusCode: Int?
    var statusMessage: String?

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }

    init(success: Bool?, statusCode: Int?, statusMessage: String?) {
        self.success = success
        self.statusCode = statusCode
        self.statusMessage = statusMessage
    }
}

protocol ServiceMaganerProtocol {
    func fetchRequest<T: Codable>(with request: URLRequest,
                                         completion: @escaping(Result<T, RequestError>) -> Void)
    func getError(response: URLResponse, data: Data) -> RequestError
}

extension ServiceMaganerProtocol {
    
    func getError(response: URLResponse, data: Data) -> RequestError {
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return RequestError(success: false, statusCode: 00, statusMessage: "ServerError_Description".description)
        }
        
        
        switch httpResponse.statusCode {
        case 400:
            return RequestError(success: false, statusCode: 400, statusMessage: "ServerError_Request".description)
        case 401:
            return RequestError(success: false, statusCode: 401, statusMessage:  "ServerError_Unauthorized".description)
        case 404:
            return RequestError(success: false, statusCode: 404, statusMessage:  "ServerError_NotFound".description)
        case 500:
            return RequestError(success: false, statusCode: 500, statusMessage:  "ServerError_Unavailable".description)
        default:
            return RequestError(success: false, statusCode: 400, statusMessage:  "ServerError_Default".description)
        }
    }
}

class ServicesManager: ServiceMaganerProtocol {
    
    private let session = URLSession.shared
    private static let share = ServicesManager()
    private var retries = 0
    private let retryLimit = 3
    
    
    public func fetchRequest<T: Codable>(with request: URLRequest,
                                         completion: @escaping(Result<T, RequestError>) -> Void) {
        
        self.session.dataTask(with: request, completionHandler: { data, response, error in
            
            //MARK: validated error
            if let err = error {
                let nsError = err as NSError
                let possibleInternetErrors = [
                    NSURLErrorNotConnectedToInternet,
                    NSURLErrorNetworkConnectionLost,
                    NSURLErrorCannotConnectToHost,
                    NSURLErrorCannotFindHost,
                ]
                if possibleInternetErrors.contains(nsError.code) && self.retries < self.retryLimit {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        ServicesManager.share.fetchRequest(with: request, completion: completion)
                    }
                } else {
                    completion(.failure(RequestError(success: false,statusCode: nsError.code, statusMessage: nsError.description)))
                }
                
            }
            
            guard let response = response, let data = data else {
                return completion(.failure(
                    RequestError(success: false,statusCode: 0, statusMessage: "ServerError_Unknow".description))
                )
            }
            
            //MARK: validated response
            guard let httpResp = response as? HTTPURLResponse,
            (200...299).contains(httpResp.statusCode) else {
                completion(.failure(self.getError(response: response, data: data)))
                return
            }
            
            if let respData = Mapper<T>().map(object: data) {
                completion(.success(respData))
            } else {
                completion(.failure(
                    RequestError(success: false, statusCode: 400, statusMessage: "ServerError_Decoder".description)
                ))
            }
            
        }).resume()
    }
    
}


class MockServiceManager: ServiceMaganerProtocol {
    
    var name: String
    
    public init(nameFile:String) {
        self.name = nameFile
    }
    
    func fetchRequest<T>(with request: URLRequest, completion: @escaping (Result<T, RequestError>) -> Void) where T : Decodable, T : Encodable {
        
        let error = RequestError(success: false, statusCode: 400, statusMessage:"ServerError_Decoder".description)
        
        do {
            if let bundlePath = Bundle.main.path(forResource: name,ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: bundlePath), options: .mappedIfSafe)
                
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                guard let resonse = Mapper<T>().map(object: jsonResult) else {
                    return completion(.failure(error))
                }
                return completion(.success(resonse))
            }
            
        } catch {
            return completion(.failure(error as! RequestError))
        }
        
        return completion(.failure(error))
        
    }
    
}

