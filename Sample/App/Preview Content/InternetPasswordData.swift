import Foundation
import StealthyStash

public struct CredentialPropertyData: Codable {
  public let account: String
  public let data: String
  public let accessGroup: String?
  public let createdAt: Date
  public let modifiedAt: Date
  public let description: String?
  public let service: String?
  public let comments: String?
  public let type: Int?
  public let label: String?
  public let url: URL?
  public let autenticationType: Int?
  public let isSynchronizable: Bool?
}

extension CredentialPropertyData {
  static let collection = {
    let decoder = JSONDecoder()
    let url = Bundle.main.url(forResource: "credential-properties", withExtension: "json")
    let data = try! Data(contentsOf: url!)
    decoder.dateDecodingStrategy = .secondsSince1970
    return try! decoder.decode([CredentialPropertyData].self, from: data)
  }()
}

extension Synchronizable {
  init(_ booleanValue : Bool?) {
    switch booleanValue {
      
    case .none:
      self = .any
    case .some(true):
      self = .enabled
    case .some(false):
      self = .disabled
    }
  }
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
      isSynchronizable: .init( data.isSynchronizable)
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
      isSynchronizable: .init(data.isSynchronizable)
    )
  }
}

extension AnyStealthyProperty {
  public init(data: CredentialPropertyData) {
    let property: any StealthyProperty
    if data.service != nil {
      property = GenericPasswordItem(data: data)
    } else {
      property = InternetPasswordItem(data: data)
    }
    self.init(property: property)
  }

  public static let previewCollection = CredentialPropertyData.collection.map(Self.init(data:))
}
