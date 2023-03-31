public struct UpdateQuerySet {
  internal let query: SecretDictionary
  internal let attributes: SecretDictionary
  // let id: String

  internal init(query: SecretDictionary, attributes: SecretDictionary, id _: String) {
    self.query = query
    self.attributes = attributes
    // self.id = id
  }
}

extension UpdateQuerySet {
  internal init<SecretPropertyType: SecretProperty>(
    from previousItem: SecretPropertyType,
    to newItem: SecretPropertyType
  ) {
    let query = previousItem.fetchQuery()
    let attributes = newItem.updateQuery()
    self.init(query: query, attributes: attributes, id: newItem.id)
  }
}
