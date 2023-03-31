import Foundation
import Security

extension InternetPasswordItem {
  public func uniqueAttributes() -> SecretDictionary {
    [
      kSecAttrAccount as String: account,
      kSecAttrAccessGroup as String: accessGroup,
      kSecAttrServer as String: server,
      kSecAttrProtocol as String: self.protocol?.cfValue,
      kSecAttrPort as String: port,
      kSecAttrPath as String: path
    ]
  }

  public func otherProperties() -> SecretDictionary {
    [
      kSecAttrSynchronizable as String: isSynchronizable.cfValue,
      kSecAttrDescription as String: description,
      kSecAttrType as String: type,
      kSecAttrLabel as String: label
    ]
  }

  public static let propertyType: SecretPropertyType = .internet

  public var id: String {
    [
      account,
      server,
      self.protocol?.rawValue,
      authenticationType,
      port?.description,
      path
    ].compactMap { $0 }.joined()
  }

  init(
    common: CommonAttributes,
    server: String? = nil,
    protocol: ServerProtocol? = nil,
    authenticationType _: AuthenticationType? = nil,
    port: Int? = nil,
    path: String? = nil
  ) {
    self.init(
      account: common.account,
      data: common.data,
      accessGroup: common.accessGroup,
      createdAt: common.createdAt,
      modifiedAt: common.modifiedAt,
      description: common.description,
      type: common.type,
      label: common.label,
      server: server,
      protocol: `protocol`,
      port: port?.trimZero(),
      path: path,
      isSynchronizable: common.isSynchronizable
    )
  }

  public init(dictionary: [String: Any]) throws {
    let common: CommonAttributes = try .init(dictionary: dictionary, isRaw: false)
    let server: String? = try dictionary.requireOptional(kSecAttrServer)
    let protocolString: CFString? = try dictionary.requireOptional(kSecAttrProtocol)
    let `protocol`: ServerProtocol? = protocolString.flatMap(ServerProtocol.init(number:))
    let port: Int? = try dictionary.requireOptional(kSecAttrPort)
    let path: String? = try dictionary.requireOptional(kSecAttrPath)
    self.init(
      common: common,
      server: server,
      protocol: `protocol`,
      port: port?.trimZero(),
      path: path
    )
  }

  public init(rawDictionary: [String: Any]) throws {
    let common: CommonAttributes = try .init(dictionary: rawDictionary, isRaw: true)
    let server: String? = try rawDictionary.requireOptional(kSecAttrServer)
    let protocolString: CFString? = try rawDictionary.requireOptional(kSecAttrProtocol)
    let `protocol`: ServerProtocol? = protocolString.flatMap(ServerProtocol.init(number:))
    let port: Int? = try rawDictionary.requireOptional(kSecAttrPort)
    let path: String? = try rawDictionary.requireOptional(kSecAttrPath)
    self.init(
      common: common,
      server: server,
      protocol: `protocol`,
      port: port?.trimZero(),
      path: path
    )
  }
}
