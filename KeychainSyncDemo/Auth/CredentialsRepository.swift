
protocol CredentialsRepository {
  
  func create(_ item: AnyCredentialProperty) throws
  func update(_ item: AnyCredentialProperty) throws
  func query(_ query: Query) throws -> [AnyCredentialProperty]
}
