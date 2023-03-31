public struct UpdateQuerySet {
  internal let query: StealthyDictionary
  internal let attributes: StealthyDictionary
  // let id: String

  internal init(query: StealthyDictionary, attributes: StealthyDictionary, id _: String) {
    self.query = query
    self.attributes = attributes
    // self.id = id
  }
}

extension UpdateQuerySet {
  internal init<StealthyPropertyType: StealthyProperty>(
    from previousItem: StealthyPropertyType,
    to newItem: StealthyPropertyType
  ) {
    let query = previousItem.fetchQuery()
    let attributes = newItem.updateQuery()
    self.init(query: query, attributes: attributes, id: newItem.id)
  }
}
