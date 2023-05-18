#if canImport(Security)
  import Security
  extension StealthyProperty {
    /// Returns an `AnyStealthyProperty` instance that wraps this `StealthyProperty`.
    public func eraseToAnyProperty() -> AnyStealthyProperty {
      .init(property: self)
    }

    /// Returns a dictionary containing the class of this `StealthyProperty`.
    public func classDictionary() -> StealthyDictionary {
      [kSecClass as String: Self.propertyType.secClass]
    }

    /// Returns a dictionary containing the data of this `StealthyProperty`.
    public func dataDictionary() -> StealthyDictionary {
      [kSecValueData as String: data]
    }

    /// Returns a dictionary containing all attributes of this `StealthyProperty`.
    public func attributesDictionary() -> StealthyDictionary {
      otherProperties().merging(with: dataDictionary(), overwrite: true)
    }

    /// Returns a dictionary containing the unique attributes of this `StealthyProperty`.
    public func fetchQuery() -> StealthyDictionary {
      uniqueAttributes().merging(with: classDictionary(), overwrite: false)
    }

    /// Returns a dictionary containing the attributes to add this `StealthyProperty`.
    public func addQuery() -> StealthyDictionary {
      fetchQuery().merging(with: attributesDictionary(), overwrite: false)
    }

    /// Returns a dictionary containing the attributes to update this `StealthyProperty`.
    public func updateQuery() -> StealthyDictionary {
      uniqueAttributes().merging(with: attributesDictionary(), overwrite: false)
    }

    /// Returns a dictionary containing the attributes to delete this `StealthyProperty`.
    public func deleteQuery() -> StealthyDictionary {
      fetchQuery()
    }

    /// Returns an `UpdateQuerySet` instance containing the query and attributes
    /// to update this `StealthyProperty`.
    public func updateQuerySet() -> UpdateQuerySet {
      .init(query: fetchQuery(), attributes: attributesDictionary())
    }
  }

#endif
