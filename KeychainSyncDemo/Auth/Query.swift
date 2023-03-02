import Security

protocol Query {
  var type : SecretPropertyType { get }
  func keychainDictionary (withDefaults defaults : [String : Any?]?) -> [String : Any?]
}
