

@available(*, deprecated)
struct DefunctSecretPropertyUpdate {
  let property : AnySecretProperty
  @available(*, deprecated)
  let shouldDelete : Bool
}


struct SecretPropertyUpdate {
  internal init(previousProperty: AnySecretProperty?, newProperty: AnySecretProperty?) {
    self.previousProperty = previousProperty
    self.newProperty = newProperty
  }
  
  let previousProperty : AnySecretProperty?
  let newProperty : AnySecretProperty?
}

extension SecretPropertyUpdate {
  init<SecretPropertyType : SecretProperty>(previousProperty: SecretPropertyType?, newProperty: SecretPropertyType?) {
    self.init(previousProperty: previousProperty.map(AnySecretProperty.init(property:)), newProperty: newProperty.map(AnySecretProperty.init(property:)))
  }
}

protocol ModelQueryBuilder {
  associatedtype QueryType
  associatedtype SecretModelType : SecretModel
  
  static func queries(from query: QueryType) -> [String : Query]
  
  static func model(from properties: [String : [AnySecretProperty]]) throws -> SecretModelType?
  
  static func properties(from model: SecretModelType, for operation: ModelOperation) -> [DefunctSecretPropertyUpdate]
  
  static func updates(from previousItem: SecretModelType, to newItem: SecretModelType) -> [SecretPropertyUpdate]
  
}
