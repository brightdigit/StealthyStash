
struct CompositeCredentials : SingletonModel {
  typealias QueryBuilder = CompositeCredentialsQueryBuilder
  

  
  
  internal init(userName: String, password: String?, token: String?) {
    self.userName = userName
    self.password = password
    self.token = token
  }
  
  var userName : String
  
  var password : String?
  
  var token : String?
  
  
}
