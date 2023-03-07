
struct CompositeCredentialsQueryBuilder : ModelQueryBuilder {
  
  
  
  static func updates(from previousItem: CompositeCredentials, to newItem: CompositeCredentials) -> [SecretPropertyUpdate] {
    let newPasswordData = newItem.password.flatMap{
      $0.data(using: .utf8)
    }.map{
      InternetPasswordItem(account: newItem.userName, data: $0)
    }
    
    let oldPasswordData = previousItem.password.flatMap{
      $0.data(using: .utf8)
    }.map{
      InternetPasswordItem(account: previousItem.userName, data: $0)
    }
    
    
    let previousTokenData  = previousItem.token.flatMap{
      $0.data(using: .utf8)
    }.map{
      GenericPasswordItem(account: previousItem.userName, data: $0)
    }
    
    let newTokenData = newItem.token.flatMap{
      $0.data(using: .utf8)
    }.map{
      GenericPasswordItem(account: newItem.userName, data: $0)
    }
    
    let passwordUpdate = SecretPropertyUpdate(previousProperty: oldPasswordData, newProperty: newPasswordData)
    let tokenUpdate = SecretPropertyUpdate(previousProperty: previousTokenData, newProperty: newTokenData)
    return [passwordUpdate, tokenUpdate]
  }
  
  static func properties(from model: CompositeCredentials, for operation: ModelOperation) -> [AnySecretProperty] {
    let passwordData = model.password.flatMap{
      $0.data(using: .utf8)
    }
    
    let passwordProperty : AnySecretProperty = .init(
        property: InternetPasswordItem(
          account: model.userName,
          data: passwordData ?? .init()
        )
      )
    
    
    
    let tokenData  =  model.token.flatMap{
      $0.data(using: .utf8)
    }
    
    let tokenProperty : AnySecretProperty = .init(
        property: GenericPasswordItem(
          account: model.userName,
          data: tokenData ?? .init()
        )
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
