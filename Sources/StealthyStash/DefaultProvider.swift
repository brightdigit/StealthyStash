import Security

/// Provides any default values for creating or querying the keychain.
public protocol DefaultProvider {
  /// Returns the attribute dictionary for the keychain query.
  /// - Parameter type: What type of keychain item to query.
  /// - Returns: The attribute dictionary.
  func attributesForQuery(ofType type: StealthyPropertyType?) -> StealthyDictionary
  func attributesForNewItem(ofType type: StealthyPropertyType) -> StealthyDictionary
}
