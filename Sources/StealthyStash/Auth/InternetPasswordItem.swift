import Foundation
import Security

public struct InternetPasswordItem: Identifiable, Hashable, SecretProperty {
  public func uniqueAttributes() -> SecretDictionary {
    [
      kSecAttrAccount as String: account,
      kSecAttrAccessGroup as String: accessGroup,
      kSecAttrServer as String: server,
      kSecAttrProtocol as String: self.protocol,
      kSecAttrPort as String: port,
      kSecAttrPath as String: path
    ]
  }

  public func otherProperties() -> SecretDictionary {
    [
      kSecAttrSynchronizable as String: isSynchronizable,
      kSecAttrDescription as String: description,
      kSecAttrType as String: type,
      kSecAttrLabel as String: label
    ]
  }

  public static let propertyType: SecretPropertyType = .internet

  public var id: String {
    [account,
     server,
     self.protocol?.rawValue,
     authenticationType,
     port?.description,
     path].compactMap { $0 }.joined()
  }

  public init(
    account: String,
    data: Data,
    accessGroup: String? = nil,
    createdAt: Date? = nil,
    modifiedAt: Date? = nil,
    description: String? = nil,
    comment: String? = nil,
    type: Int? = nil,
    label: String? = nil,
    server: String? = nil,
    protocol: ServerProtocol? = nil,
    authenticationType: AuthenticationType? = nil,
    port: Int? = nil,
    path: String? = nil,
    isSynchronizable: Bool? = nil
  ) {
    self.account = account
    self.data = data
    self.accessGroup = accessGroup
    self.createdAt = createdAt
    self.modifiedAt = modifiedAt
    self.description = description
    self.comment = comment
    self.type = type
    self.label = label
    self.server = server
    self.protocol = `protocol`
    self.authenticationType = authenticationType
    self.port = port
    self.path = path
    self.isSynchronizable = isSynchronizable
  }

  public let account: String
  public let data: Data

  public let accessGroup: String?
  public let createdAt: Date?
  public let modifiedAt: Date?
  public let description: String?
  public let comment: String?
  public let type: Int?
  public let label: String?
  public let server: String?
  public let `protocol`: ServerProtocol?
  public let authenticationType: AuthenticationType?
  public let port: Int?
  public let path: String?
  public let isSynchronizable: Bool?
}

extension InternetPasswordItem {
  public init(
    account: String,
    data: Data,
    accessGroup: String? = nil,
    url: URL? = nil,
    createdAt: Date? = nil,
    modifiedAt: Date? = nil,
    description: String? = nil,
    comment _: String? = nil,
    type: Int? = nil,
    label: String? = nil,
    authenticationType _: AuthenticationType? = nil,
    isSynchronizable: Bool? = nil
  ) {
    self.init(
      account: account,
      data: data,
      accessGroup: accessGroup,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      description: description,
      type: type?.trimZero(),
      label: label,
      server: url?.host,
      protocol: url.flatMap(\.scheme).flatMap(ServerProtocol.init(scheme:)),
      port: url?.port?.trimZero(),
      path: url?.path,
      isSynchronizable: isSynchronizable
    )
  }

  public init(dictionary: [String: Any]) throws {
    let account: String = try dictionary.require(kSecAttrAccount)
    let data: Data = try dictionary.require(kSecValueData)
    let accessGroup: String? = try dictionary.requireOptional(kSecAttrAccessGroup)
    let createdAt: Date? = try dictionary.requireOptional(kSecAttrCreationDate)
    let modifiedAt: Date? = try dictionary.requireOptional(kSecAttrModificationDate)
    let description: String? = try dictionary.requireOptional(kSecAttrDescription)
    let type: Int? = try dictionary.requireOptionalCF(kSecAttrType)
    let label: String? = try dictionary.requireOptionalCF(kSecAttrLabel)
    let server: String? = try dictionary.requireOptional(kSecAttrServer)
    let protocolString: CFString? = try dictionary.requireOptional(kSecAttrProtocol)
    let `protocol`: ServerProtocol? = protocolString.flatMap(ServerProtocol.init(number:))
    let port: Int? = try dictionary.requireOptional(kSecAttrPort)
    let path: String? = try dictionary.requireOptional(kSecAttrPath)
    let isSynchronizable: Bool? = try dictionary.requireOptional(kSecAttrSynchronizable)
    self.init(
      account: account,
      data: data,
      accessGroup: accessGroup,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      description: description,
      type: type?.trimZero(),
      label: label,
      server: server,
      protocol: `protocol`,
      port: port?.trimZero(),
      path: path,
      isSynchronizable: isSynchronizable
    )
  }

  public init(rawDictionary: [String: Any]) throws {
    let account: String = try rawDictionary.require(kSecAttrAccount)
    let data: Data = try rawDictionary.require(kSecValueData)
    let accessGroup: String? = try rawDictionary.requireOptional(kSecAttrAccessGroup)
    let createdAt: Date? = try rawDictionary.requireOptional(kSecAttrCreationDate)
    let modifiedAt: Date? = try rawDictionary.requireOptional(kSecAttrModificationDate)
    let description: String? = try rawDictionary.requireOptional(kSecAttrDescription)
    let type: Int? = try rawDictionary.requireOptionalCF(kSecAttrType)
    let label: String? = try rawDictionary.requireOptionalCF(kSecAttrLabel)
    let server: String? = try rawDictionary.requireOptional(kSecAttrServer)
    let protocolString: CFString? = try rawDictionary.requireOptional(kSecAttrProtocol)
    let `protocol`: ServerProtocol? = protocolString.flatMap(ServerProtocol.init(number:))
    let port: Int? = try rawDictionary.requireOptional(kSecAttrPort)
    let path: String? = try rawDictionary.requireOptional(kSecAttrPath)
    let isSynchronizable: Bool? = try rawDictionary.requireOptional(kSecAttrSynchronizable)
    self.init(
      account: account,
      data: data,
      accessGroup: accessGroup,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      description: description,
      type: type?.trimZero(),
      label: label,
      server: server,
      protocol: `protocol`,
      port: port?.trimZero(),
      path: path,
      isSynchronizable: isSynchronizable
    )
  }
}
