import Foundation

public protocol CredentialsContainer {
  func fetch() throws -> Credentials?
  func save(credentials: Credentials) throws
  func reset() throws -> Credentials.ResetResult
}
