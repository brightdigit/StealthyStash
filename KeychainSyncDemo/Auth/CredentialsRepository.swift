
protocol CredentialsRepository {
  
  func create(_ item: AnyCredentialProperty) throws
  func update(_ item: AnyCredentialProperty) throws
  func query(_ query: Query) throws -> [AnyCredentialProperty]
  
  @available(*, deprecated)
  func create(_ item: InternetPasswordItem) throws
  @available(*, deprecated)
  func update(_ item: InternetPasswordItem) throws
  @available(*, deprecated)
  func queryItems(_ query: Query) throws -> [InternetPasswordItem]  
}
