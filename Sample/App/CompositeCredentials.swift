import StealthyStash

struct CompositeCredentials: StealthyModel {
  typealias QueryBuilder = CompositeCredentialsQueryBuilder

  internal init(userName: String, password: String?, token: String?) {
    self.userName = userName
    self.password = password
    self.token = token
  }

  let userName: String

  let password: String?

  let token: String?
}
