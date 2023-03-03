
struct CompositeCredentialsQueryBuilder : ModelQueryBuilder {
  static func properties(from model: CompositeCredentials, for operation: ModelOperation) -> [AnySecretProperty] {
    let passwordProperty : (any SecretProperty)? = model.password.flatMap{
      $0.data(using: .utf8)
    }
    .map{
      InternetPasswordItem(account: model.userName, data: $0)
    }
    
    let tokenProperty : (any SecretProperty)? =  model.token.flatMap{
      $0.data(using: .utf8)
    }
    .map{
      GenericPasswordItem(account: model.userName, data: $0)
    }
    
    return [passwordProperty, tokenProperty]
      .compactMap{$0}
      .map(AnySecretProperty.init(property:))
  }
  
  static func queries(from query: Void) -> [String : Query] {
    return [
      "password" : TypeQuery(type: .internet),
      "token" : TypeQuery(type: .generic)
    ]
  }
  
  static func model(from properties: [String : [AnySecretProperty]]) throws -> CompositeCredentials? {
    let properties = properties.values.flatMap{$0}
    
    guard let username = properties.map({$0.account}).first else {
        return nil
      }
    let password = properties
      .first{$0.propertyType == .internet}?
      .data
    let token = properties.first{$0.propertyType == .generic}?.data
    
    return CompositeCredentials(userName: username, password: password?.string()  , token: token?.string())
  }
  
  typealias QueryType = Void
  
  typealias SecretModelType = CompositeCredentials
  
  
  
}
