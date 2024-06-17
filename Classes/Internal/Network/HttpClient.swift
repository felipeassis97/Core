//
//  HttpClient.swift
//  Pods
//
//  Created by Felipe Assis on 18/6/2024.
//

import Foundation

struct HTTPClient: IHttpClient {
    //MARK: POST
    func post<T>(path: String, 
                 header: [String : String]? = nil,
                 body: [String : String]? = nil,
                 responseModel: T.Type?) async throws -> Result<T?, RequestError> where T : Decodable {
        
        guard let url = URL(string: path) else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        request.httpMethod = "POST"
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        return try await validateResponse(request: request, responseModel: responseModel)
    }
    
    //MARK: GET
    func get<T: Decodable>(path: String,
                           header: [String : String]? = nil,
                           responseModel: T.Type?) async throws -> Result<T?, RequestError> {
        
        guard let url = URL(string: path) else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        request.httpMethod = "GET"

        return try await validateResponse(request: request, responseModel: responseModel)
    }
    
    //MARK: Generate response by request
    private func validateResponse<T: Decodable>(request: URLRequest, responseModel: T.Type?) async throws -> Result<T?, RequestError> {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            
            switch response.statusCode {
            case 200...201:
                guard responseModel != nil else {
                    return .success(nil)
                }
                guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    return .failure(.decodeError)
                }
                return .success(decodedResponse)
                
            case 400...499:
                return .failure(.notFound)
                
            case 500...599:
                return .failure(.badRequest)
                
            default:
                return .failure(.unknownError(error: "Status code: \(response.statusCode)"))
            }
        }
        catch {
            return .failure(.unknownError(error: "Unknown error: \(error)"))
        }
    }
}




