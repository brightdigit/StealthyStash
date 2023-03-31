import Security

public protocol Query {
  var type: SecretPropertyType { get }
  func keychainDictionary() -> SecretDictionary
}

extension Query {
  public func keychainDictionary() -> SecretDictionary {
    [
      kSecClass as String: type.secClass,
      kSecReturnAttributes as String: true,
      kSecReturnData as String: true,
      kSecAttrSynchronizable as String: kSecAttrSynchronizableAny,
      kSecMatchLimit as String: kSecMatchLimitAll
    ]
  }
}
