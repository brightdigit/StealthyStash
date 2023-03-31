public struct UpdateQuerySet {
  internal let query: StealthyDictionary
  internal let attributes: StealthyDictionary

  public init(query: StealthyDictionary, attributes: StealthyDictionary) {
    self.query = query
    self.attributes = attributes
  }
}

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
