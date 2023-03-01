//
//  CredentialProperty.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 3/1/23.
//

import Foundation
import FloxBxAuth

public enum CredentialPropertyType {
  case internet
  case generic
}

extension CredentialPropertyType {
  var secClass : CFString {
    switch self {
    case .internet:
      return kSecClassInternetPassword
    case .generic:
      return kSecClassGenericPassword
    }
  }
  
  init?(secClass : CFString) {
    switch secClass {
    case kSecClassGenericPassword:
      self = .generic
    case kSecClassInternetPassword:
      self = .internet
    default:
      return nil
    }
  }
  
  var propertyType : any CredentialProperty.Type {
    switch self {
    case .internet:
      return InternetPasswordItem.self
    case .generic:
      return GenericPasswordItem.self
    }
  }
  
  var sfSymbolName : String {
    switch self {
    case .internet:
      return "network"
    case .generic:
      return "key.fill"
    }
  }
}

public struct AnyCredentialProperty : Identifiable, Hashable {
  public  init(property: any CredentialProperty) {
    self.property = property
  }
  
  public static func == (lhs: AnyCredentialProperty, rhs: AnyCredentialProperty) -> Bool {
    Swift.type(of: lhs.property).propertyType == Swift.type(of: rhs.property).propertyType && lhs.id == rhs.id
  }
  
  public var id: String {
    return property.id
  }
  
  
  public let property : any CredentialProperty
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(property)
  }
}

extension AnyCredentialProperty {
  var account : String {
    return self.property.account
  }
  var data : Data {
    return self.property.data
  }
  public var dataString : String {
    return self.property.dataString
  }
var accessGroup : String? {
  self.property.accessGroup
}
var createdAt : Date? {
  self.property.createdAt
}
var modifiedAt : Date? {
  self.property.modifiedAt
}
var description: String? {
  self.property.description
}
var comment : String? {
  self.property.comment
}
var type : Int? {
  self.property.type
}
var label : String? {
  self.property.label
}
var isSynchronizable : Bool? {
  self.property.isSynchronizable
}
  
  var server : String? {
    guard let property = self.property as? InternetPasswordItem else {
      return nil
    }
    return property.server
  }
    var `protocol` : ServerProtocol? {
      guard let property = self.property as? InternetPasswordItem else {
        return nil
      }
      return property.protocol
    }
      var port : Int? {
        guard let property = self.property as? InternetPasswordItem else {
          return nil
        }
        return property.port
      }
        var path : String? {
          guard let property = self.property as? InternetPasswordItem else {
            return nil
          }
          return property.path
        }
  
  init (builder : CredentialPropertyBuilder) throws {
    let property = try builder.secClass.propertyType.init(builder: builder)
    self.init(property: property)
  }
}

extension AnyCredentialProperty {
  init(propertyType: CredentialPropertyType, dictionary: [String: Any]) throws {
    
    let property = try propertyType.propertyType.init(dictionary: dictionary)
    self.init(property: property)
  }
}

extension AnyCredentialProperty {
  var propertyType : CredentialPropertyType {
    return Swift.type(of: self.property).propertyType
  }
}

public protocol CredentialProperty : Identifiable, Hashable {
  static var propertyType : CredentialPropertyType { get }
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
  
  func addQuery () -> [String : Any?]
  init(dictionary : [String : Any]) throws
  init(builder: CredentialPropertyBuilder) throws
}

extension CredentialProperty {
  func eraseToAnyProperty () -> AnyCredentialProperty {
    .init(property: self)
  }
  
  public var dataString : String {
    String(data: self.data, encoding: .utf8) ?? ""
  }
}
