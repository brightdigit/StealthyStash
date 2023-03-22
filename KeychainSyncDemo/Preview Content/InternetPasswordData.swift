//
//  InternetPasswordData.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/24/23.
//

import Foundation
import FloxBxAuth

public struct CredentialPropertyData : Codable {
  public let account : String
  public let data : String
  public let accessGroup : String?
  public let createdAt: Date
  public let modifiedAt : Date
  public let description: String?
  public let service: String?
  public let comments: String?
  public let type : Int?
  public let label: String?
  public let url : URL?
  public let autenticationType : Int?
  public let isSynchronizable: Bool?
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


public extension AnySecretProperty {
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
