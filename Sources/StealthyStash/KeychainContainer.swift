// #if canImport(Security)
//  import Foundation
//  import Security
//
//  #if canImport(FoundationNetworking)
//    import FoundationNetworking
//  #endif
//
//  // swiftlint:disable:next line_length todo
//  // TODO: Add support for types and labels -- https://medium.com/macoclock/retrieve-multiple-values-from-keychain-77641248f4a1
//  struct KeychainContainer: CredentialsContainer {
//    internal let accessGroup: String
//    internal let serviceName: String
//
//    init(accessGroup: String, serviceName: String) {
//      self.accessGroup = accessGroup
//      self.serviceName = serviceName
//    }
//
//    @available(*, deprecated)
//    private func upsertAccount(
//      _ account: String,
//      andToken token: String
//    ) throws {
//      var tokenItem: CFTypeRef?
//      let tokenStatus = SecItemCopyMatching(tokenAccountQuery, &tokenItem)
//      if tokenStatus == errSecItemNotFound {
//        let status = SecItemAdd(
//          queryForAdding(account: account, token: token),
//          nil
//        )
//        guard status == errSecSuccess else {
//          throw KeychainError.unhandledError(status: status)
//        }
//      } else {
//        guard tokenStatus == errSecSuccess else {
//          throw KeychainError.unhandledError(status: tokenStatus)
//        }
//        let status = SecItemUpdate(
//          tokenUpdateQuery,
//          attributesForUpdating(account: account, token: token)
//        )
//        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
//        guard status == errSecSuccess else {
//          throw KeychainError.unhandledError(status: status)
//        }
//      }
//    }
//
//    @available(*, deprecated)
//    private func upsertAccount(
//      _ account: String,
//      andPassword password: String
//    ) throws {
//      var item: CFTypeRef?
//      let status = SecItemCopyMatching(passwordAccountQuery, &item)
//      if status == errSecItemNotFound {
//        let status = SecItemAdd(queryForAdding(account: account, password: password), nil)
//        guard status == errSecSuccess else {
//          throw KeychainError.unhandledError(status: status)
//        }
//      } else {
//        guard status == errSecSuccess else {
//          throw KeychainError.unhandledError(status: status)
//        }
//        let status = SecItemUpdate(
//          passwordUpdateQuery,
//          attributesForUpdating(account: account, password: password)
//        )
//        guard status != errSecItemNotFound else {
//          throw KeychainError.noPassword
//        }
//        guard status == errSecSuccess else {
//          throw KeychainError.unhandledError(status: status)
//        }
//      }
//    }
//
//    func fetch() throws -> Credentials? {
//      var item: CFTypeRef?
//      let status = SecItemCopyMatching(passwordAccountQuery, &item)
//      guard status != errSecItemNotFound else {
//        return nil
//      }
//      guard status == errSecSuccess else {
//        throw KeychainError.unhandledError(status: status)
//      }
//      // swiftlint:disable indentation_width
//      guard let existingItem = item as? [String: Any],
//            let passwordData = existingItem[kSecValueData as String] as? Data,
//            let password = String(data: passwordData, encoding: String.Encoding.utf8),
//            let account = existingItem[kSecAttrAccount as String] as? String
//      // swiftlint:enable indentation_width
//      else {
//        throw KeychainError.unexpectedPasswordData
//      }
//      var tokenItem: CFTypeRef?
//      let tokenStatus = SecItemCopyMatching(tokenAccountQuery, &tokenItem)
//
//      // swiftlint:disable indentation_width
//      if let existingItem = tokenItem as? [String: Any],
//         let passwordData = existingItem[kSecValueData as String] as? Data,
//         let token = String(data: passwordData, encoding: String.Encoding.utf8),
//         tokenStatus == errSecSuccess {
//        // swiftlint:enable indentation_width
//        return Credentials(username: account, password: password, token: token)
//      } else {
//        return Credentials(username: account, password: password)
//      }
//    }
//
//    @available(*, deprecated)
//    @discardableResult
//    private func deleteToken() throws -> Bool {
//      let tokenQuery: [String: Any] = [
//        kSecClass as String: kSecClassGenericPassword,
//        kSecAttrService as String: serviceName,
//        kSecAttrAccessGroup as String: accessGroup
//      ]
//      let tokenStatus = SecItemDelete(tokenQuery as CFDictionary)
//
//      switch tokenStatus {
//      case errSecItemNotFound:
//        return false
//
//      case errSecSuccess:
//        return true
//
//      default:
//        throw KeychainError.unhandledError(status: tokenStatus)
//      }
//    }
//
//    @available(*, deprecated)
//    @discardableResult
//    private func deletePassword() throws -> Bool {
//      let tokenStatus = SecItemDelete(deletePasswordQuery)
//
//      switch tokenStatus {
//      case errSecItemNotFound:
//        return false
//
//      case errSecSuccess:
//        return true
//
//      default:
//        throw KeychainError.unhandledError(status: tokenStatus)
//      }
//    }
//
//    @available(*, deprecated)
//    func reset() throws -> Credentials.ResetResult {
//      let didDeleteToken = try deleteToken()
//      let didDeletePassword = try deletePassword()
//      return .init(didDeletePassword: didDeletePassword, didDeleteToken: didDeleteToken)
//    }
//
//    func save(credentials: Credentials) throws {
//      try upsertAccount(credentials.username, andPassword: credentials.password)
//      if let token = credentials.token {
//        try upsertAccount(credentials.username, andToken: token)
//      }
//    }
//  }
//
// #endif
