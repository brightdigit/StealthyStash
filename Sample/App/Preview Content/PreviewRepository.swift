import StealthyStash

struct PreviewRepository : SecretsRepository {

  
  func delete(_ item: AnySecretProperty) throws {
    
  }
  
  let items : [AnySecretProperty]
  func create(_ item: AnySecretProperty) throws {
    
  }
  
  func update(_ item: AnySecretProperty) throws {
    
  }
  
  func update<SecretPropertyType>(_ item: SecretPropertyType, from previousItem: SecretPropertyType) throws where SecretPropertyType : SecretProperty {
    
  }
  
  func query(_ query: Query) throws -> [AnySecretProperty] {
    return self.items
  }
  
}
