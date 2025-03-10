import Security
import SwiftUI

class KeychainHelper {
    static let shared = KeychainHelper()
    
    func save(_ value: String, forKey key: String) {
        let data = Data(value.utf8)
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        
        SecItemDelete(query) // Remove existing item if exists
        SecItemAdd(query, nil) // Add new item
    }
    
    func get(forKey key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var dataTypeRef: AnyObject?
        if SecItemCopyMatching(query, &dataTypeRef) == noErr, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func delete(forKey key: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        SecItemDelete(query)
    }
}
