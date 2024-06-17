//
//  HttpClient.swift
//  Pods
//
//  Created by Felipe Assis on 18/6/2024.
//

import Foundation

public enum RequestError: Error {
    case decode
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "Decoded error"
        case .unauthorized:
            return "Unauthorized"
        default:
            return "Unknown error"
        }
    }
}
