//
//  InternetPasswordData.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/24/23.
//

import Foundation


struct InternetPasswordData : Codable {
  let account : String
  let data : String
  let accessGroup : String?
  let createdAt: Date
  let modifiedAt : Date
  let description: String?
  let type : Int?
  let label: String?
  let url : URL?
  let autenticationType : Int?
  let isSynchronizable: Bool?
}


extension InternetPasswordData {
  static let collection = {
    let decoder = JSONDecoder()
    let url = Bundle.main.url(forResource: "internet-passwords", withExtension: "json")
    let data = try! Data(contentsOf: url!)
    decoder.dateDecodingStrategy = .secondsSince1970
    return try! decoder.decode([InternetPasswordData].self, from:  data)
  }()
}

extension InternetPasswordItem {
  static let previewCollection = {
    InternetPasswordData.collection.map(
      InternetPasswordItem.init
    )
  }()
}

extension AnyCredentialProperty {
  static let _previewDictionary : [CredentialPropertyType : [any CredentialProperty]] = [
    .internet : InternetPasswordItem.previewCollection
  ]
  
  static let previewCollections = _previewDictionary.mapValues{
    $0.map(AnyCredentialProperty.init(property:))
  }
}

extension InternetPasswordItem {
  init(data: InternetPasswordData) {
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
