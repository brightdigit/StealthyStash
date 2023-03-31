import Security

extension StealthyProperty {
  public var dataString: String {
    String(data: data, encoding: .utf8) ?? ""
  }

  public func eraseToAnyProperty() -> AnyStealthyProperty {
    .init(property: self)
  }

  public func dataDictionary() -> StealthyDictionary {
    [kSecValueData as String: data]
  }

  public func attributesDictionary() -> StealthyDictionary {
    otherProperties().merging(with: dataDictionary(), overwrite: true)
  }

  public func classDictionary() -> StealthyDictionary {
    [kSecClass as String: Self.propertyType.secClass]
  }

  public func fetchQuery() -> StealthyDictionary {
    uniqueAttributes().merging(with: classDictionary(), overwrite: false)
  }

  public func addQuery() -> StealthyDictionary {
    fetchQuery().merging(with: attributesDictionary(), overwrite: false)
  }

  public func updateQuery() -> StealthyDictionary {
    uniqueAttributes().merging(with: attributesDictionary(), overwrite: false)
  }

  public func deleteQuery() -> StealthyDictionary {
    fetchQuery()
  }

  public func updateQuerySet() -> UpdateQuerySet {
    .init(query: fetchQuery(), attributes: attributesDictionary(), id: id)
  }
}
