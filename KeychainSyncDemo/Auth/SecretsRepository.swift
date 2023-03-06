
protocol SecretsRepository {
  
  func create(_ item: AnySecretProperty) throws
  #warning("if key changed ... need to know old key")
  func update(_ item: AnySecretProperty) throws
  func delete(_ item: AnySecretProperty) throws
  func query(_ query: Query) throws -> [AnySecretProperty]
}
