//
//  KeychainRepository.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/23/23.
//

import Foundation
import FloxBxAuth


struct KeychainRepository : CredentialRepository {
  let defaultServiceName : String
  let defaultServerName : String
  let defaultAccessGroup : String?
  let defaultSynchronizable : Bool?
  
  func addItem(_ item: CredentialItem) throws {
    let dictionaryAny = [
      kSecClass as String: item.itemClass.classValue,
      kSecAttrAccount as String: item.account,
      kSecValueData as String: item.data,
      kSecAttrService as String: (item.itemClass == .generic ? (item.serviceName ?? defaultServiceName) : nil),
      kSecAttrServer as String: (item.itemClass == .internet ? (item.server ?? defaultServerName) : nil) ,
      kSecAttrAccessGroup as String: item.accessGroup ?? defaultAccessGroup as Any,
      kSecAttrSynchronizable as String: item.isSynchronizable ?? self.defaultSynchronizable
    ] as [String : Any?]
    
    let query = dictionaryAny.compactMapValues{ $0} as CFDictionary
    
    let status = SecItemAdd(query, nil)
    
    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
  }
}
