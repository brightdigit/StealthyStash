import Security

public protocol DefaultProvider {
  func attributesForQuery(ofType type: StealthyPropertyType?) -> StealthyDictionary
  func attributesForNewItem(ofType type: StealthyPropertyType) -> StealthyDictionary
}
