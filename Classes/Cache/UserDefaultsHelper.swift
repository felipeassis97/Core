//
//  UserDefaultsHelper.swift
//  Pods
//
//  Created by Felipe Assis on 19/6/2024.
//

import Foundation

struct UserDefaultsHelper: ICacheManager {
    func save(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func get(for key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    func remove(for key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
