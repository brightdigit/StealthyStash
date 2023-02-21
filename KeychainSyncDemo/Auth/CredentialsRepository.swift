
protocol CredentialsRepository {
  func create(_ item: InternetPasswordItem) throws
  func update(_ item: InternetPasswordItem) throws
  func query(_ query: Query) throws -> [InternetPasswordItem]  
}
