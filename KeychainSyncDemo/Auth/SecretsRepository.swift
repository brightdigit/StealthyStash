
protocol SecretsRepository {
  
  func create(_ item: AnySecretProperty) throws
  func update(_ item: AnySecretProperty) throws
  func delete(_ item: AnySecretProperty) throws
  func query(_ query: Query) throws -> [AnySecretProperty]
}
