//
//  CredentialProperty.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 3/1/23.
//

import Foundation
import FloxBxAuth

public typealias SecretDictionary = [String : Any?]

public protocol SecretProperty : Identifiable, Hashable {
  static var propertyType : SecretPropertyType { get }
  var id : String { get }
   var account : String { get }
   var data : Data { get }
 
  var accessGroup : String? { get }
  var createdAt : Date? { get }
  var modifiedAt : Date? { get }
  var description: String? { get }
  var comment : String? { get }
  var type : Int? { get }
  var label : String? { get }
  var isSynchronizable : Bool? { get }
  
  func addQuery () -> SecretDictionary
  func deleteQuery () -> SecretDictionary
  func updateQuerySet () -> UpdateQuerySet
  
  func uniqueAttributes () -> SecretDictionary
  func otherProperties () -> SecretDictionary
  
  init(dictionary : [String : Any]) throws
  init(builder: SecretPropertyBuilder) throws
}

extension Dictionary {
  func merging (with rhs: Self, overwrite : Bool) -> Self {
    self.merging(rhs) { lhs, rhs in
      overwrite ? rhs : lhs
    }
  }
}

extension SecretProperty {
  func eraseToAnyProperty () -> AnySecretProperty {
    .init(property: self)
  }
  
  public var dataString : String {
    String(data: self.data, encoding: .utf8) ?? ""
  }
  
  func dataDictionary () -> SecretDictionary {
    return [kSecValueData as String : self.data]
  }
  
  func attributesDictionary () -> SecretDictionary {
    self.otherProperties().merging(with: dataDictionary(), overwrite: true)
  }
  
  func classDictionary () -> SecretDictionary {
    return [kSecClass as String : Self.propertyType.secClass]
  }
  
  func fetchQuery() -> SecretDictionary {
    self.uniqueAttributes().merging(with: classDictionary(), overwrite: false)
  }
  
  public func addQuery () -> SecretDictionary {
    return self.fetchQuery().merging(with: attributesDictionary(), overwrite: false)
  }
  
  public func deleteQuery () -> SecretDictionary {
    return  self.fetchQuery()
  }
  
  public func updateQuerySet () -> UpdateQuerySet {
    return .init(query: self.fetchQuery(), attributes: self.attributesDictionary(), id: self.id)
  }
}
