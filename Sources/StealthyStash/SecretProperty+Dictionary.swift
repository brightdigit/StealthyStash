import Security

extension SecretProperty {
  public func eraseToAnyProperty() -> AnySecretProperty {
    .init(property: self)
  }

  public var dataString: String {
    String(data: data, encoding: .utf8) ?? ""
  }

  public func dataDictionary() -> SecretDictionary {
    [kSecValueData as String: data]
  }

  public func attributesDictionary() -> SecretDictionary {
    otherProperties().merging(with: dataDictionary(), overwrite: true)
  }

  public func classDictionary() -> SecretDictionary {
    [kSecClass as String: Self.propertyType.secClass]
  }

  public func fetchQuery() -> SecretDictionary {
    uniqueAttributes().merging(with: classDictionary(), overwrite: false)
  }

  public func addQuery() -> SecretDictionary {
    fetchQuery().merging(with: attributesDictionary(), overwrite: false)
  }

  public func updateQuery() -> SecretDictionary {
    uniqueAttributes().merging(with: attributesDictionary(), overwrite: false)
  }

  public func deleteQuery() -> SecretDictionary {
    fetchQuery()
  }

  public func updateQuerySet() -> UpdateQuerySet {
    .init(query: fetchQuery(), attributes: attributesDictionary(), id: id)
  }
}
