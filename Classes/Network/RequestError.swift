//
//  HttpClient.swift
//  Pods
//
//  Created by Felipe Assis on 18/6/2024.
//

import Foundation

public enum RequestError: Error {
    case invalidURL
    case decodeError
    case noResponse
    case notFound
    case badRequest
    case unknownError(error: String)
    case requestError(error: String)
}
