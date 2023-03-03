import Security

struct TypeQuery : Query {
  internal init(type: SecretPropertyType) {
    self.type = type
  }
  
  public let type : SecretPropertyType

  func keychainDictionary (withDefaults defaults : [String : Any?]? = nil) -> [String : Any?] {
    return [
        kSecClass as String: type.secClass,
        kSecAttrServer as String: type == .internet ? defaults?[kSecAttrServer as String].flatMap{$0} : nil,
        kSecAttrService as String: type == .generic ? defaults?[kSecAttrService as String].flatMap{$0} : nil,
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true,
        kSecAttrAccessGroup as String: defaults?[kSecAttrAccessGroup as String].flatMap{$0},
        kSecAttrSynchronizable as String: kSecAttrSynchronizableAny,
        kSecMatchLimit as String: kSecMatchLimitAll
      ]
  }
}
