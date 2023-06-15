import Foundation

internal struct CommonAttributes {
  internal let account: String
  internal let data: Data
  internal let accessGroup: String?
  internal let createdAt: Date?
  internal let modifiedAt: Date?
  internal let description: String?
  internal let comment: String?
  internal let type: Int?
  internal let label: String?
  internal let isSynchronizable: Synchronizable

  internal init(
    account: String,
    data: Data,
    accessGroup: String?,
    createdAt: Date?,
    modifiedAt: Date?,
    description: String?,
    comment: String?,
    type: Int?,
    label: String?,
    isSynchronizable: Synchronizable
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
    self.isSynchronizable = isSynchronizable
  }
}

#if canImport(Security)
  extension CommonAttributes {
    // swiftlint:disable:next function_body_length
    internal init(dictionary: StealthyDictionary, isRaw: Bool) throws {
      let account: String = try dictionary.require(kSecAttrAccount)
      let data: Data = try dictionary.require(kSecValueData)
      let accessGroup: String? = try dictionary.requireOptional(kSecAttrAccessGroup)
      let createdAt: Date? = try dictionary.requireOptional(kSecAttrCreationDate)
      let modifiedAt: Date? = try dictionary.requireOptional(kSecAttrModificationDate)
      let description: String? = try dictionary.requireOptional(kSecAttrDescription)
      let comment: String? = try dictionary.requireOptional(kSecAttrComment)
      let type: Int? = try dictionary.requireOptionalCF(kSecAttrType)
      let label: String? = try dictionary.requireOptionalCF(kSecAttrLabel)
      let isSynchronizable: Synchronizable
      if isRaw {
        let value = dictionary[kSecAttrSynchronizable as String]
        isSynchronizable = value.flatMap(Synchronizable.init(rawDictionaryValue:)) ?? .any
      } else {
        let syncValue: Int? = try dictionary.requireOptional(kSecAttrSynchronizable)
        isSynchronizable = .init(syncValue)
      }
      self.init(
        account: account,
        data: data,
        accessGroup: accessGroup,
        createdAt: createdAt,
        modifiedAt: modifiedAt,
        description: description,
        comment: comment,
        type: type?.trimZero(),
        label: label,
        isSynchronizable: isSynchronizable
      )
    }
  }
#endif
