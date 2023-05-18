/// A `struct` representing a set of update queries.
public struct UpdateQuerySet {
  /// The query to fetch the item to update.
  internal let query: StealthyDictionary

  /// The attributes to update on the item.
  internal let attributes: StealthyDictionary

  /// Initializes a new `UpdateQuerySet`.
  /// - Parameters:
  ///    - query: The query to fetch the item to update.
  ///    - attributes: The attributes to update on the item.
  public init(query: StealthyDictionary, attributes: StealthyDictionary) {
    self.query = query
    self.attributes = attributes
  }
}

#if canImport(Security)
  extension UpdateQuerySet {
    internal init<StealthyPropertyType: StealthyProperty>(
      from previousItem: StealthyPropertyType,
      to newItem: StealthyPropertyType
    ) {
      let query = previousItem.fetchQuery()
      let attributes = newItem.updateQuery()
      self.init(query: query, attributes: attributes)
    }
  }
#endif
