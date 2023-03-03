
protocol ModelQueryBuilder {
  associatedtype QueryType
  associatedtype SecretModelType : SecretModel
  
  static func queries(from query: QueryType) -> [String : Query]
  
  static func model(from properties: [String : [AnySecretProperty]]) throws -> SecretModelType?
  
  static func properties(from model: SecretModelType, for operation: ModelOperation) -> [AnySecretProperty]
  
}
