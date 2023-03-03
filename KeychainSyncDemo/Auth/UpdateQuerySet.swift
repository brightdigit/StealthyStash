////
////  CompositeSecret.swift
////  KeychainSyncDemo
////
////  Created by Leo Dion on 3/2/23.
////
//
//import Foundation
//
////extension Data {
////  func string (encoding: String.Encoding = .utf8) -> String? {
////    return String(data: self, encoding: encoding)
////  }
////}
////
////protocol QueryCollection {
////  var queries : [String : Query] { get }
////}
//
////
////struct CredentialsQueryCollection : SingletonQuery {
////  let queries: [String : Query] = {
////    return [
////      SecretPropertyType.generic.secClass as String: TypeQuery(type: .generic),
////      SecretPropertyType.internet.secClass as String: TypeQuery(type: .internet)
////    ]
////  }()
////
////
////
////}
////protocol SingletonQuery : QueryCollection {
////  init()
////}
//
public struct UpdateQuerySet {
  public init(query: [String : Any?], attributes: [String : Any?], id: String) {
    self.query = query
    self.attributes = attributes
    self.id = id
  }
  
  public let query : [String : Any?]
  public let attributes : [String : Any?]
  public let id : String
}
//
//enum ModelOperation {
//  case adding
//  case updating
//  case deleting
//}
//
//protocol ModelQueryBuilder {
//  associatedtype QueryType
//  associatedtype SecretModelType : SecretModel
//  
//  static func queries(from query: QueryType) -> [String : Query]
//  
//  static func model(from properties: [String : [AnySecretProperty]]) throws -> SecretModelType?
//  
//  static func properties(from model: SecretModelType, for operation: ModelOperation) -> [AnySecretProperty]
//  
//}
//
//protocol SecretModel {
//  associatedtype QueryBuilder : ModelQueryBuilder where QueryBuilder.SecretModelType == Self
//}
//
//protocol SingletonModel : SecretModel where Self.QueryBuilder.QueryType == Void {
//  
//}
//
//extension SecretsRepository {
//  func create<SecretModelType: SecretModel>(_ model: SecretModelType) throws {
//    let properties = SecretModelType.QueryBuilder.properties(from: model, for: .adding)
//    for property in properties {
//      try self.create(property)
//    }
//  }
//  
//  func update<SecretModelType: SecretModel>(_ model: SecretModelType) throws {
//    let properties = SecretModelType.QueryBuilder.properties(from: model, for: .updating)
//    for property in properties {
//      try self.update(property)
//    }
//  }
//  
//  func delete<SecretModelType: SecretModel>(_ model: SecretModelType) throws {
//    let properties = SecretModelType.QueryBuilder.properties(from: model, for: .updating)
//    for property in properties {
//      try self.delete(property)
//    }
//  }
//  
//  func fetch<SecretModelType : SecretModel>(_ query: SecretModelType.QueryBuilder.QueryType) async throws -> SecretModelType? {
//    let properties = try await withThrowingTaskGroup(of: (String, [AnySecretProperty]).self, returning: [String: [AnySecretProperty]].self) { taskGroup in
//      let queries = SecretModelType.QueryBuilder.queries(from: query)
//      for (id, query) in queries {
//        
//        
//        taskGroup.addTask {
//          return try (id, self.query(query))
//        }
//      }
//      
//      return try await taskGroup.reduce(into: [String : [AnySecretProperty]]()) { result, pair in
//        result[pair.0] = pair.1
//      }
//    }
//    return try SecretModelType.QueryBuilder.model(from: properties)
//  }
//}
//
//struct CompositeCredentialsQueryBuilder : ModelQueryBuilder {
//  static func properties(from model: CompositeCredentials, for operation: ModelOperation) -> [AnySecretProperty] {
//    let passwordProperty : (any SecretProperty)? = model.password.flatMap{
//      $0.data(using: .utf8)
//    }
//    .map{
//      InternetPasswordItem(account: model.userName, data: $0)
//    }
//    
//    let tokenProperty : (any SecretProperty)? =  model.token.flatMap{
//      $0.data(using: .utf8)
//    }
//    .map{
//      GenericPasswordItem(account: model.userName, data: $0)
//    }
//    
//    return [passwordProperty, tokenProperty]
//      .compactMap{$0}
//      .map(AnySecretProperty.init(property:))
//  }
//  
//  static func queries(from query: Void) -> [String : Query] {
//    return [
//      "password" : TypeQuery(type: .internet),
//      "token" : TypeQuery(type: .generic)
//    ]
//  }
//  
//  static func model(from properties: [String : [AnySecretProperty]]) throws -> CompositeCredentials? {
//    let properties = properties.values.flatMap{$0}
//    
//    guard let username = properties.map({$0.account}).first else {
//        return nil
//      }
//    let password = properties
//      .first{$0.propertyType == .internet}?
//      .data
//    let token = properties.first{$0.propertyType == .generic}?.data
//    
//    return CompositeCredentials(userName: username, password: password?.string()  , token: token?.string())
//  }
//  
//  typealias QueryType = Void
//  
//  typealias SecretModelType = CompositeCredentials
//  
//  
//  
//}
//
//struct CompositeCredentials : SingletonModel {
//  typealias QueryBuilder = CompositeCredentialsQueryBuilder
//  
//
//  
//  
//  internal init(userName: String, password: String?, token: String?) {
//    self.userName = userName
//    self.password = password
//    self.token = token
//  }
//  
//  var userName : String
//  
//  var password : String?
//  
//  var token : String?
//  
//  
//}
