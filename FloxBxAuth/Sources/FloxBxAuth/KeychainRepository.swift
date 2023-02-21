//
//  KeychainRepository.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/23/23.
//

import Foundation


public struct KeychainRepository : LegacyCredentialRepository {
  public init(defaultServiceName: String, defaultServerName: String, defaultAccessGroup: String? = nil, defaultSynchronizable: Bool? = nil) {
    self.defaultServiceName = defaultServiceName
    self.defaultServerName = defaultServerName
    self.defaultAccessGroup = defaultAccessGroup
    self.defaultSynchronizable = defaultSynchronizable
  }
  
  let defaultServiceName : String
  let defaultServerName : String
  let defaultAccessGroup : String?
  let defaultSynchronizable : Bool?
  
  public func addItem(_ item: LegacyCredentialItem) throws {
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
