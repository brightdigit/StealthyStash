#if canImport(Security)
  import Foundation
  import Security

  #if canImport(FoundationNetworking)
    import FoundationNetworking
  #endif

  extension KeychainContainer {
    internal var tokenAccountQuery: CFDictionary {
      [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: serviceName,
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true,
        kSecAttrAccessGroup as String: accessGroup
      ] as CFDictionary
    }

    internal var tokenUpdateQuery: CFDictionary {
      [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: serviceName,
        kSecAttrAccessGroup as String: accessGroup
      ] as CFDictionary
    }

    internal var passwordAccountQuery: CFDictionary {
      [
        kSecClass as String: kSecClassInternetPassword,
        kSecAttrServer as String: serviceName,
        kSecMatchLimit as String: kSecMatchLimitOne,
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true,
        kSecAttrAccessGroup as String: accessGroup,
        kSecAttrSynchronizable as String: kSecAttrSynchronizableAny
      ] as CFDictionary
    }

    internal var passwordUpdateQuery: CFDictionary {
      [
        kSecClass as String: kSecClassInternetPassword,
        kSecAttrServer as String: serviceName,
        kSecAttrAccessGroup as String: accessGroup,
        kSecAttrSynchronizable as String: kSecAttrSynchronizableAny
      ] as CFDictionary
    }

    internal var deleteTokenQuery: CFDictionary {
      [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: serviceName,
        kSecAttrAccessGroup as String: accessGroup
      ] as CFDictionary
    }

    internal var deletePasswordQuery: CFDictionary {
      [
        kSecClass as String: kSecClassInternetPassword,
        kSecAttrServer as String: serviceName,
        kSecAttrAccessGroup as String: accessGroup,
        kSecAttrSynchronizable as String: kSecAttrSynchronizableAny
      ] as CFDictionary
    }

    private static func data(
      from string: String,
      using encoding: String.Encoding = .utf8,
      allowLossyConversion: Bool = false
    ) -> Data {
      guard let data = string.data(
        using: encoding,
        allowLossyConversion: allowLossyConversion
      ) else {
        preconditionFailure("Can't extract data from string: \(string)")
      }

      return data
    }

    internal func queryForAdding(account: String, password: String) -> CFDictionary {
      let passwordData = Self.data(from: password)

      return [
        kSecClass as String: kSecClassInternetPassword,
        kSecAttrAccount as String: account,
        kSecAttrServer as String: serviceName,
        kSecValueData as String: passwordData,
        kSecAttrAccessGroup as String: accessGroup,

        kSecAttrSynchronizable as String: true
      ] as CFDictionary
    }

    internal func attributesForUpdating(
      account: String,
      password: String
    ) -> CFDictionary {
      let passwordData = Self.data(from: password)
      return [
        kSecAttrAccount as String: account,
        kSecValueData as String: passwordData,

        kSecAttrSynchronizable as String: true
      ] as CFDictionary
    }

    internal func queryForAdding(account: String, token: String) -> CFDictionary {
      let tokenData = Self.data(from: token)

      return [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: account,
        kSecValueData as String: tokenData,
        kSecAttrService as String: serviceName,
        kSecAttrAccessGroup as String: accessGroup
      ] as CFDictionary
    }

    internal func attributesForUpdating(account: String, token: String) -> CFDictionary {
      let tokenData = Self.data(from: token)
      return [
        kSecAttrAccount as String: account,
        kSecValueData as String: tokenData
      ] as CFDictionary
    }
  }
#endif
