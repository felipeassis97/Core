//
//  IUserDefaults.swift
//  Pods
//
//  Created by Felipe Assis on 19/6/2024.
//

import Foundation

public protocol ICacheManager {
    func save(key: String, value: String)
    func get(for key: String) -> String?
    func remove(for key: String)
}

//MARK: Bind
public func getCacheManger() -> ICacheManager {
    return UserDefaultsHelper()
}
