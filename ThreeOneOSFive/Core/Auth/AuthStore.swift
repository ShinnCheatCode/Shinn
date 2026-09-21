import Foundation
import Security

final class RoleAuthStore {
    static let shared = RoleAuthStore()
    private let service = "com.yangjiii.3105.roleauth"
    private let defaultPassword = "080109"

    func verify(_ input: String, for role: UserRole) -> Bool {
        switch role {
        case .member: return true
        case .owner, .admin: return input == (read(role) ?? defaultPassword)
        }
    }

    func change(_ newPassword: String, for role: UserRole) {
        guard role.requiresPassword else { return }
        save(newPassword, for: role)
    }

    private func read(_ role: UserRole) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: role.rawValue,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let data = item as? Data,
              let value = String(data: data, encoding: .utf8) else { return nil }
        return value
    }

    private func save(_ password: String, for role: UserRole) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: role.rawValue
        ]
        SecItemDelete(query as CFDictionary)
        var attributes = query
        attributes[kSecValueData as String] = Data(password.utf8)
        SecItemAdd(attributes as CFDictionary, nil)
    }
}

final class AuthStore {
    static let shared = AuthStore()
    private let service = "com.yangjiii.3105.auth"
    private let account = "appPassword"
    private let defaultPassword = "080109"

    func verify(_ input: String) -> Bool {
        return input == (readPassword() ?? defaultPassword)
    }

    func changePassword(_ newPassword: String) {
        savePassword(newPassword)
    }

    private func readPassword() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess,
              let data = item as? Data,
              let value = String(data: data, encoding: .utf8) else { return nil }
        return value
    }

    private func savePassword(_ password: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
        var attributes = query
        attributes[kSecValueData as String] = Data(password.utf8)
        SecItemAdd(attributes as CFDictionary, nil)
    }
}