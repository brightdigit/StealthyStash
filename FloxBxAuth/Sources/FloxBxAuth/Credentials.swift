public struct Credentials {
  public let username: String
  public let password: String
  public let token: String?

  public init(username: String, password: String, token: String? = nil) {
    self.username = username
    self.password = password
    self.token = token
  }

  public func withToken(_ token: String) -> Credentials {
    Credentials(username: username, password: password, token: token)
  }

  public func withoutToken() -> Credentials {
    Credentials(username: username, password: password, token: nil)
  }
}
