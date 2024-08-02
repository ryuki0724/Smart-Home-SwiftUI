//
//  KeychainManager.swift
//  SmartHome
//
//  Created by 吉田龍生 on 2024/5/1.
//

import Foundation
import Security

class KeychainManager {
    
    static let shared = KeychainManager()
    
    func check(username: String? = nil, email: String, password: String? = nil) -> Bool {
        let query = [
            kSecClass as String            : kSecClassGenericPassword,
            kSecAttrAccount as String      : email,
            kSecMatchLimit as String       : kSecMatchLimitOne,
            kSecReturnData as String       : kCFBooleanTrue as Any,
            kSecReturnAttributes as String : kCFBooleanTrue as Any
        ] as [String : Any]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status == errSecSuccess {
            if username == nil && password == nil { return true }
            
            if let existingItem = item as? [String: Any],
               let retrievedData = existingItem[kSecValueData as String] as? Data,
               let storedInfo = try? JSONDecoder().decode([String].self, from: retrievedData),
               storedInfo.count == 2,
               storedInfo[0] == username && storedInfo[1] == password {
                return true
            }
        }
        return false
    }
    
    func save(username: String, email: String, password: String) -> Bool {
        if check(email: email) {
            return false
        }
        
        guard let accountData = try? JSONEncoder().encode([username, password]) else {
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : email,
            kSecValueData as String   : accountData
        ]
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    func delete(email: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : email
        ]
        
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
