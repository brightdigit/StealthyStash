import StealthyStash

@StealthyModel
struct CompositeCredentials {
#warning("deal with queries")
  #warning("add init(properties:)")
  init?(properties: [String: AnyStealthyProperty]) {
    guard let account = properties["password"]?.account else {
      return nil
    }
    self.account = account
    self.password = properties["password"]?.dataString
    self.token = properties["token"]?.dataString
  }
  
  internal init(account: String, password: String?, token: String?) {
    self.account = account
    self.password = password
    self.token = token
  }

  let account: String

  // @Key
  #warning("Add @Key")
  // @InternetPassword
#warning("Add @Internet")
#warning("Add @Generic")
  let password: String?

  let token: String?
}
