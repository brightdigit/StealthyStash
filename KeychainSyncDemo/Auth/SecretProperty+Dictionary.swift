import Security


extension SecretProperty {
  func eraseToAnyProperty () -> AnySecretProperty {
    .init(property: self)
  }
  
  public var dataString : String {
    String(data: self.data, encoding: .utf8) ?? ""
  }
  
  func dataDictionary () -> SecretDictionary {
    return [kSecValueData as String : self.data]
  }
  
  func attributesDictionary () -> SecretDictionary {
    self.otherProperties().merging(with: dataDictionary(), overwrite: true)
  }
  
  func classDictionary () -> SecretDictionary {
    return [kSecClass as String : Self.propertyType.secClass]
  }
  
  func fetchQuery() -> SecretDictionary {
    self.uniqueAttributes().merging(with: classDictionary(), overwrite: false)
  }
  
  public func addQuery () -> SecretDictionary {
    return self.fetchQuery().merging(with: attributesDictionary(), overwrite: false)
  }
  
  public func deleteQuery () -> SecretDictionary {
    return  self.fetchQuery()
  }
  
  public func updateQuerySet () -> UpdateQuerySet {
    return .init(query: self.fetchQuery(), attributes: self.attributesDictionary(), id: self.id)
  }
}
 
