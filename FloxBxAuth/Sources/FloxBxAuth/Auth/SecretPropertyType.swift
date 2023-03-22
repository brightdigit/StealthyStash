//
//  CredentialProperty.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 3/1/23.
//

import Foundation
import FloxBxAuth

public enum SecretPropertyType {
  case internet
  case generic
}

public extension SecretPropertyType {
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
  
  var propertyType : any SecretProperty.Type {
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
