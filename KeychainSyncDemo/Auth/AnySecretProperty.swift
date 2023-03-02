//
//  CredentialProperty.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 3/1/23.
//

import Foundation
import FloxBxAuth


public struct AnySecretProperty : Identifiable, Hashable {
  public  init(property: any SecretProperty) {
    self.property = property
  }
  
  public static func == (lhs: AnySecretProperty, rhs: AnySecretProperty) -> Bool {
    Swift.type(of: lhs.property).propertyType == Swift.type(of: rhs.property).propertyType && lhs.id == rhs.id
  }
  
  public var id: String {
    return property.id
  }
  
  
  public let property : any SecretProperty
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(property)
  }
}

extension AnySecretProperty {
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
  
  init (builder : SecretPropertyBuilder) throws {
    let property = try builder.secClass.propertyType.init(builder: builder)
    self.init(property: property)
  }
}

extension AnySecretProperty {
  init(propertyType: SecretPropertyType, dictionary: [String: Any]) throws {
    
    let property = try propertyType.propertyType.init(dictionary: dictionary)
    self.init(property: property)
  }
}

extension AnySecretProperty {
  var propertyType : SecretPropertyType {
    return Swift.type(of: self.property).propertyType
  }
  
  
}
