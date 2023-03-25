public struct UpdateQuerySet {
  init(query: [String: Any?], attributes: [String: Any?], id: String) {
    self.query = query
    self.attributes = attributes
    self.id = id
  }

  let query: [String: Any?]
  let attributes: [String: Any?]
  let id: String
}

extension UpdateQuerySet {
  init<SecretPropertyType: SecretProperty>(from previousItem: SecretPropertyType, to newItem: SecretPropertyType) {
    let query = previousItem.fetchQuery()
    let attributes = newItem.updateQuery()
    self.init(query: query, attributes: attributes, id: newItem.id)
  }
}

extension UpdateQuerySet {
  func merging(with rhs: SecretDictionary, overwrite: Bool) -> Self {
    let rhs = rhs.deepCompactMapValues()
    let newQuery = query.deepCompactMapValues().merging(with: rhs, overwrite: overwrite)
    // let attributes = attributes.merging(with: rhs, overwrite: overwrite)
    return .init(query: newQuery, attributes: attributes, id: id)
  }
}
