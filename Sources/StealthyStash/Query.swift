import Security

public protocol Query {
  var type: StealthyPropertyType { get }
  func keychainDictionary() -> StealthyDictionary
}

extension Query {
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
