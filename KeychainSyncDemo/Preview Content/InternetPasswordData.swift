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

extension AnyCredentialProperty {
//  
//  static let _previewDictionary : [CredentialPropertyType : [any CredentialProperty]] = [
//    .internet : InternetPasswordItem.previewCollection
//  ]

}

//extension InternetPasswordItem {
//  init(data: InternetPasswordData) {
//    self.init(
//      account: data.account,
//      data: data.data.data(using: .utf8)!,
//      accessGroup: data.accessGroup,
//      createdAt: data.createdAt,
//      modifiedAt: data.modifiedAt,
//      description: data.description,
//      type: data.type,
//      label: data.label,
//      server: data.url?.host,
//      protocol: data.url?.scheme.flatMap(ServerProtocol.init(scheme:)),
//      port: data.url?.port,
//      path: data.url?.path,
//      isSynchronizable: data.isSynchronizable
//    )
//  }
//}
