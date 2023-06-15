/// A protocol for queries to the keychain.
public protocol Query {
  /// The type of property being queried.
  var type: StealthyPropertyType { get }

  #if canImport(Security)
    /// Returns a dictionary of keychain query parameters.
    /// - Returns: A dictionary of keychain query parameters.
    func keychainDictionary() -> StealthyDictionary
  #endif
}

#if canImport(Security)
  import Security

  extension Query {
    /// Returns a dictionary of keychain query parameters.
    /// - Returns: A dictionary of keychain query parameters.
    public func keychainDictionary() -> StealthyDictionary {
      [
        kSecClass as String: type.secClass,
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true,
        kSecAttrSynchronizable as String: kSecAttrSynchronizableAny,
        kSecMatchLimit as String: kSecMatchLimitAll
      ]
    }
  }
#endif
