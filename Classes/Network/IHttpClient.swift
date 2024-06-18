//
//  IHttpClient.swift
//  Pods
//
//  Created by Felipe Assis on 18/6/2024.
//

import Foundation

public protocol IHttpClient {
    func get<T: Decodable>(path: String,
                           header: [String: String]?,
                           responseModel: T.Type?) async throws -> Result<T?, RequestError>
    
    func post<T: Decodable>(path: String,
                            header: [String: String]?,
                            body: [String: String]?,
                            responseModel: T.Type?) async throws -> Result<T?, RequestError>
}

//MARK: Bind
public func getClient() -> IHttpClient {
    return HTTPClient()
}
