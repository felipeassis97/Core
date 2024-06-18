//
//  KeychainHelper.swift
//  Pods
//
//  Created by Felipe Assis on 19/6/2024.
//

import Foundation
struct KeychainHelper: ISecureStorage {
    func save(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }

               let query: [String: Any] = [
                   kSecClass as String: kSecClassGenericPassword,
                   kSecAttrAccount as String: key,
                   kSecValueData as String: data
               ]

               SecItemDelete(query as CFDictionary)
               SecItemAdd(query as CFDictionary, nil)
    }
    
    func get(for key: String) -> String? {
        let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: key,
                    kSecReturnData as String: kCFBooleanTrue!,
                    kSecMatchLimit as String: kSecMatchLimitOne
                ]

                var dataTypeRef: AnyObject?
                let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

                if status == errSecSuccess {
                    if let data = dataTypeRef as? Data {
                        return String(data: data, encoding: .utf8)
                    }
                }
                return nil
    }
    
    func remove(for key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
