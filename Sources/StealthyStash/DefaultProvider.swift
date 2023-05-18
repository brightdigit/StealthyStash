/// A protocol that provides default values for creating or querying the keychain.
public protocol DefaultProvider {
  /// Returns the attribute dictionary for the keychain query.
  ///   - Parameter type: The type of keychain item to query.
  ///   - Returns: The attribute dictionary.
  func attributesForQuery(ofType type: StealthyPropertyType?) -> StealthyDictionary

  /// Returns the attribute dictionary for a new keychain item.
  /// - Parameter type: The type of keychain item to create.
  /// - Returns: The attribute dictionary.
  func attributesForNewItem(ofType type: StealthyPropertyType) -> StealthyDictionary
}
