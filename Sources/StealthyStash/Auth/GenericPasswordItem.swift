import Foundation
import Security

public struct GenericPasswordItem: Identifiable, Hashable, SecretProperty {
  public func otherProperties() -> SecretDictionary {
    [
      kSecAttrGeneric as String: gerneic,
      kSecAttrDescription as String: description,
      kSecAttrComment as String: comment,
      kSecAttrType as String: type,
      kSecAttrLabel as String: label
    ]
  }

  public static var propertyType: SecretPropertyType {
    .generic
  }

  public init(
    account: String,
    data: Data,
    service: String? = nil,
    accessGroup: String? = nil,
    createdAt: Date? = nil,
    modifiedAt: Date? = nil,
    description: String? = nil,
    comment: String? = nil,
    type: Int? = nil,
    label: String? = nil,
    gerneic: Data? = nil,
    isSynchronizable: Bool? = nil
  ) {
    self.account = account
    self.data = data
    self.service = service
    self.accessGroup = accessGroup
    self.createdAt = createdAt
    self.modifiedAt = modifiedAt
    self.description = description
    self.comment = comment
    self.type = type
    self.label = label
    self.gerneic = gerneic
    self.isSynchronizable = isSynchronizable
  }

  public var id: String {
    [account,
     service].compactMap { $0 }.joined()
  }

  public func uniqueAttributes() -> SecretDictionary {
    [
      kSecAttrAccount as String: account,
      kSecAttrService as String: service,
      kSecAttrAccessGroup as String: accessGroup,
      kSecAttrSynchronizable as String: isSynchronizable
    ]
  }

  public let account: String
  public let data: Data
  public let service: String?
  public let accessGroup: String?
  public let createdAt: Date?
  public let modifiedAt: Date?
  public let description: String?
  public let comment: String?
  public let type: Int?
  public let label: String?
  public let gerneic: Data?
  public let isSynchronizable: Bool?
}

extension GenericPasswordItem {
  public var dataString: String {
    String(data: data, encoding: .utf8) ?? ""
  }
}

extension GenericPasswordItem {
  public init(dictionary: [String: Any]) throws {
    let account: String = try dictionary.require(kSecAttrAccount)
    let data: Data = try dictionary.require(kSecValueData)
    let accessGroup: String? = try dictionary.requireOptional(kSecAttrAccessGroup)
    let createdAt: Date? = try dictionary.requireOptional(kSecAttrCreationDate)
    let modifiedAt: Date? = try dictionary.requireOptional(kSecAttrModificationDate)
    let description: String? = try dictionary.requireOptional(kSecAttrDescription)
    let type: Int? = try dictionary.requireOptionalCF(kSecAttrType)
    let label: String? = try dictionary.requireOptionalCF(kSecAttrLabel)
    let service: String = try dictionary.require(kSecAttrService)
    let generic: Data? = try dictionary.requireOptional(kSecAttrGeneric)
    let isSynchronizable: Bool? = try dictionary.requireOptional(kSecAttrSynchronizable)
    self.init(
      account: account,
      data: data,
      service: service,
      accessGroup: accessGroup,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      description: description,
      type: type?.trimZero(),
      label: label,
      gerneic: generic,
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
    let service: String? = try? rawDictionary.require(kSecAttrService)
    let generic: Data? = try rawDictionary.requireOptional(kSecAttrGeneric)
    let isSynchronizable: Bool? = try rawDictionary.requireOptional(kSecAttrSynchronizable)
    self.init(
      account: account,
      data: data,
      service: service,
      accessGroup: accessGroup,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      description: description,
      type: type?.trimZero(),
      label: label,
      gerneic: generic,
      isSynchronizable: isSynchronizable
    )
  }
}
