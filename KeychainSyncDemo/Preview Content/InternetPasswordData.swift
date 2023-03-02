//
//  InternetPasswordData.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/24/23.
//

import Foundation


struct CredentialPropertyData : Codable {
  let account : String
  let data : String
  let accessGroup : String?
  let createdAt: Date
  let modifiedAt : Date
  let description: String?
  let service: String?
  let comments: String?
  let type : Int?
  let label: String?
  let url : URL?
  let autenticationType : Int?
  let isSynchronizable: Bool?
}


extension CredentialPropertyData {
  static let collection = {
    let decoder = JSONDecoder()
    let url = Bundle.main.url(forResource: "credential-properties", withExtension: "json")
    let data = try! Data(contentsOf: url!)
    decoder.dateDecodingStrategy = .secondsSince1970
    return try! decoder.decode([CredentialPropertyData].self, from:  data)
  }()
}



extension GenericPasswordItem {
  init(data: CredentialPropertyData) {
    self.init(
      account: data.account,
      data: data.data.data(using: .utf8)!,
      service: data.service,
      accessGroup: data.accessGroup,
      createdAt: data.createdAt,
      modifiedAt: data.modifiedAt,
      description: data.description,
      type: data.type,
      label: data.label,
      isSynchronizable: data.isSynchronizable
    )
  }
}

extension InternetPasswordItem {
  init(data: CredentialPropertyData) {
    self.init(
      account: data.account,
      data: data.data.data(using: .utf8)!,
      accessGroup: data.accessGroup,
      createdAt: data.createdAt,
      modifiedAt: data.modifiedAt,
      description: data.description,
      type: data.type,
      label: data.label,
      server: data.url?.host,
      protocol: data.url?.scheme.flatMap(ServerProtocol.init(scheme:)),
      port: data.url?.port,
      path: data.url?.path,
      isSynchronizable: data.isSynchronizable
    )
  }
}


extension AnySecretProperty {
  init(data: CredentialPropertyData) {
    let property : any SecretProperty
    if data.service != nil {
      property = GenericPasswordItem(data: data)
    } else {
      property = InternetPasswordItem(data: data)
    }
    self.init(property: property)
  }
  
  static let previewCollection = CredentialPropertyData.collection.map(Self.init(data: ))
}
