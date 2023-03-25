@available(*, deprecated)
struct Credentials {
  let username: String
  let password: String
  let token: String?

  init(username: String, password: String, token: String? = nil) {
    self.username = username
    self.password = password
    self.token = token
  }

  func withToken(_ token: String) -> Credentials {
    Credentials(username: username, password: password, token: token)
  }

  func withoutToken() -> Credentials {
    Credentials(username: username, password: password, token: nil)
  }
}
