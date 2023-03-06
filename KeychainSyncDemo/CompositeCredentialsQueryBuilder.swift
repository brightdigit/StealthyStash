
struct CompositeCredentialsQueryBuilder : ModelQueryBuilder {
  static func properties(from model: CompositeCredentials, for operation: ModelOperation) -> [SecretPropertyUpdate] {
    let passwordData = model.password.flatMap{
      $0.data(using: .utf8)
    }
    
    let passwordProperty : SecretPropertyUpdate = SecretPropertyUpdate(
      property: .init(
        property: InternetPasswordItem(
          account: model.userName,
          data: passwordData ?? .init()
        )
      ),
      shouldDelete: passwordData == nil
    )
    
    
    
    let tokenData  =  model.token.flatMap{
      $0.data(using: .utf8)
    }
    
    let tokenProperty : SecretPropertyUpdate = SecretPropertyUpdate(
      property: .init(
        property: GenericPasswordItem(
          account: model.userName,
          data: tokenData ?? .init()
        )
      ),
      shouldDelete: tokenData == nil
    )
    
    return [passwordProperty, tokenProperty]
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
