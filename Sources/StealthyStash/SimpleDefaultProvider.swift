import Security

internal struct SimpleDefaultProvider: DefaultProvider {
  private let defaultServiceName: String
  private let defaultServerName: String
  private let defaultAccessGroup: String?
  private let defaultSynchronizable: Synchronizable

  internal init(
    defaultServiceName: String,
    defaultServerName: String,
    defaultAccessGroup: String? = nil,
    defaultSynchronizable: Synchronizable = .any
  ) {
    self.defaultServiceName = defaultServiceName
    self.defaultServerName = defaultServerName
    self.defaultAccessGroup = defaultAccessGroup
    self.defaultSynchronizable = defaultSynchronizable
  }

  internal func attributesForQuery(
    ofType type: SecretPropertyType?
  ) -> SecretDictionary {
    [
      kSecAttrServer as String: type == .internet ? defaultServerName : nil,
      kSecAttrService as String: type == .generic ? defaultServiceName : nil,
      kSecAttrAccessGroup as String: defaultAccessGroup
    ]
  }

  internal func attributesForNewItem(
    ofType type: SecretPropertyType
  ) -> SecretDictionary {
    [
      kSecAttrService as String: type == .generic ? defaultServiceName : nil,
      kSecAttrServer as String: type == .internet ? defaultServerName : nil,
      kSecAttrAccessGroup as String: defaultAccessGroup,
      kSecAttrSynchronizable as String: defaultSynchronizable.cfValue
    ]
  }
}
