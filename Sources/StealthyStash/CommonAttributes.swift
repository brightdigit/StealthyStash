import Foundation

struct CommonAttributes {
  internal init(account: String, data: Data, accessGroup: String?, createdAt: Date?, modifiedAt: Date?, description: String?, comment: String?, type: Int?, label: String?, isSynchronizable: Synchronizable) {
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

  let account: String
  let data: Data
  let accessGroup: String?
  let createdAt: Date?
  let modifiedAt: Date?
  let description: String?
  let comment: String?
  let type: Int?
  let label: String?
  let isSynchronizable: Synchronizable
}

extension CommonAttributes {
  init(dictionary: SecretDictionary, isRaw: Bool) throws {
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
      isSynchronizable = dictionary[kSecAttrSynchronizable as String].flatMap(Synchronizable.init(rawDictionaryValue:)) ?? .any
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
