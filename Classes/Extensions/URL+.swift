//
//  URL+.swift
//  Pods
//
//  Created by Felipe Assis on 18/6/2024.
//

import Foundation

extension URL {
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
                let queryItems = components.queryItems else { return nil }
        
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value?.replacingOccurrences(of: "+", with: " ")
        }
    }
}
