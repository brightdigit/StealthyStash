//
//  CompositeSecret.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 3/2/23.
//

import Foundation

extension Data {
  func string (encoding: String.Encoding = .utf8) -> String? {
    return String(data: self, encoding: encoding)
  }
}
//
//@propertyWrapper class SecretField<Value, ModelType> {
//  internal init(queryID: String, key: String) {
//    self.queryID = queryID
//    self.key = key
//  }
//
//  let queryID : String
//  let key : String
//  var value : Value?
//
//  var wrappedValue: Value {
//      get {
//          guard let value = self.value else {
//              fatalError("Cannot access field before it is initialized or fetched: \(self.key)")
//          }
//          return value
//      }
//      set {
//          self.value = newValue
//      }
//  }
//
//}

protocol QueryCollection {
  var queries : [String : Query] { get }
}


struct CredentialsQueryCollection : SingletonQuery {
  let queries: [String : Query] = {
    return [
      SecretPropertyType.generic.secClass as String: TypeQuery(type: .generic),
      SecretPropertyType.internet.secClass as String: TypeQuery(type: .internet)
    ]
  }()
  
  
  
}
protocol SingletonQuery : QueryCollection {
  init()
}

struct UpdateQuerySet {
  let query : [String : Any?]
  let attributes : [String : Any?]
  let id : String
}

protocol ModelQueryBuilder {
  associatedtype QueryType
  associatedtype SecretModelType : SecretModel
  
  static func queries(from query: QueryType) -> [String : Query]
  
  static func model(from properties: [String : [AnySecretProperty]]) throws -> SecretModelType?
  
  static func propertiesForAdding(_ model: SecretModelType) -> [AnySecretProperty]
  
  static func queriesForFetching(_ model: SecretModelType) -> [String : [String : Any]]
  
  static func attributesForUpdating(_ model: SecretModelType) -> [String : [String : Any]]
  
  static func queriesForDeleting(_ model: SecretModelType) -> [[String : Any?]]
  
  static func queriesForUpdating(_ model: SecretModelType)  -> [UpdateQuerySet]
}
protocol SecretModel {
  associatedtype QueryBuilder : ModelQueryBuilder where QueryBuilder.SecretModelType == Self
  //init?(properties : [String : [AnySecretProperty]]) throws
}
protocol SingletonModel : SecretModel where Self.QueryBuilder.QueryType == Void {
  
}
extension SecretsRepository {
  func create<SecretModelType: SecretModel>(_ model: SecretModelType) throws {
    let properties = SecretModelType.QueryBuilder.propertiesForAdding(model)
    for property in properties {
      try self.create(property)
    }
  }
  
  func update
  
//  func fetch<SecretModelType : SingletonModel>() async throws -> SecretModelType? {
//    try await self.fetch(.init())
//  }
  
  func fetch<SecretModelType : SecretModel>(_ query: SecretModelType.QueryBuilder.QueryType) async throws -> SecretModelType? {
    let properties = try await withThrowingTaskGroup(of: (String, [AnySecretProperty]).self, returning: [String: [AnySecretProperty]].self) { taskGroup in
      let queries = SecretModelType.QueryBuilder.queries(from: query)
      for (id, query) in queries {
        
        
        taskGroup.addTask {
          return try (id, self.query(query))
        }
      }
      
      return try await taskGroup.reduce(into: [String : [AnySecretProperty]]()) { result, pair in
        result[pair.0] = pair.1
      }
    }
    return try SecretModelType.QueryBuilder.model(from: properties)
  }
}
struct CompositeCredentialsQueryBuilder : ModelQueryBuilder {
  static func queries(from query: Void) -> [String : Query] {
    fatalError()
  }
  
  static func model(from properties: [String : [AnySecretProperty]]) throws -> CompositeCredentials? {
    fatalError()
  }
  
  typealias QueryType = Void
  
  typealias SecretModelType = CompositeCredentials
  
  func queriesForAdding(_ model: CompositeCredentials) -> [[String : Any?]] {
    fatalError()
  }
  
  func queriesForFetching(_ model: CompositeCredentials) -> [String : [String : Any]] {
    fatalError()
  }
  
  func attributesForUpdating(_ model: CompositeCredentials) -> [String : [String : Any]] {
    fatalError()
  }
  
  func queriesForDeleting(_ model: CompositeCredentials) -> [[String : Any?]] {
    fatalError()
  }
  
  func queriesForUpdating(_ model: CompositeCredentials) -> [UpdateQuerySet] {
    fatalError()
  }
  
  
}
struct CompositeCredentials : SingletonModel {
  typealias QueryBuilder = CompositeCredentialsQueryBuilder
  
  init?(properties: [String : [AnySecretProperty]]) throws {
    let properties = properties.values.flatMap{$0}
    
    guard let username = properties.map({$0.account}).first else {
        return nil
      }
    let password = properties
      .first{$0.propertyType == .internet}?
      .data
    let token = properties.first{$0.propertyType == .generic}?.data
    
    self.init(userName: username, password: password?.string()  , token: token?.string())
  }
  
  
  internal init(userName: String, password: String?, token: String?) {
    self.userName = userName
    self.password = password
    self.token = token
  }
  
  var userName : String
  
  var password : String?
  
  var token : String?
  
  
}
