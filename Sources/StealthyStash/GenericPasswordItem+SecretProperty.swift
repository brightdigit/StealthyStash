import Foundation
import Security

extension GenericPasswordItem {
  public static var propertyType: SecretPropertyType {
    .generic
  }

  public var id: String {
    [
      account,
      service
    ].compactMap { $0 }.joined()
  }

  internal init(
    common: CommonAttributes,
    service: String? = nil,
    generic: Data? = nil
  ) {
    self.init(
      account: common.account,
      data: common.data,
      service: service,
      accessGroup: common.accessGroup,
      createdAt: common.createdAt,
      modifiedAt: common.modifiedAt,
      description: common.description,
      comment: common.comment,
      type: common.type,
      label: common.label,
      gerneic: generic,
      isSynchronizable: common.isSynchronizable
    )
  }

  public init(dictionary: SecretDictionary) throws {
    let common: CommonAttributes = try .init(dictionary: dictionary, isRaw: false)
    let service: String = try dictionary.require(kSecAttrService)
    let generic: Data? = try dictionary.requireOptional(kSecAttrGeneric)
    self.init(
      common: common,
      service: service,
      generic: generic
    )
  }

  public init(rawDictionary: SecretDictionary) throws {
    let common: CommonAttributes = try .init(dictionary: rawDictionary, isRaw: true)
    let service: String? = try rawDictionary.requireOptional(kSecAttrService)
    let generic: Data? = try rawDictionary.requireOptional(kSecAttrGeneric)
    self.init(
      common: common,
      service: service,
      generic: generic
    )
  }

  public func uniqueAttributes() -> SecretDictionary {
    [
      kSecAttrAccount as String: account,
      kSecAttrService as String: service,
      kSecAttrAccessGroup as String: accessGroup,
      kSecAttrSynchronizable as String: isSynchronizable.cfValue
    ]
  }

  public func otherProperties() -> SecretDictionary {
    [
      kSecAttrGeneric as String: gerneic,
      kSecAttrDescription as String: description,
      kSecAttrComment as String: comment,
      kSecAttrType as String: type,
      kSecAttrLabel as String: label
    ]
  }
}
