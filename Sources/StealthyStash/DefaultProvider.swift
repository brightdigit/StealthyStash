import Security

public protocol DefaultProvider {
  func attributesForQuery(ofType type: SecretPropertyType?) -> SecretDictionary
  func attributesForNewItem(ofType type: SecretPropertyType) -> SecretDictionary
}
