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
  init(dictionary: [String: Any], isRaw: Bool) throws {
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
      let syncValue : Int? = try dictionary.requireOptional(kSecAttrSynchronizable)
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

//
//    public init(rawDictionary: [String: Any]) throws {
//      let account: String = try rawDictionary.require(kSecAttrAccount)
//      let data: Data = try rawDictionary.require(kSecValueData)
//      let accessGroup: String? = try rawDictionary.requireOptional(kSecAttrAccessGroup)
//      let createdAt: Date? = try rawDictionary.requireOptional(kSecAttrCreationDate)
//      let modifiedAt: Date? = try rawDictionary.requireOptional(kSecAttrModificationDate)
//      let description: String? = try rawDictionary.requireOptional(kSecAttrDescription)
//      let type: Int? = try rawDictionary.requireOptionalCF(kSecAttrType)
//      let label: String? = try rawDictionary.requireOptionalCF(kSecAttrLabel)
//      let service: String? = try? rawDictionary.require(kSecAttrService)
//      let generic: Data? = try rawDictionary.requireOptional(kSecAttrGeneric)
//      let isSynchronizable: CFBoolean? = try rawDictionary.requireOptional(kSecAttrSynchronizable)
//      self.init(
//        account: account,
//        data: data,
//        service: service,
//        accessGroup: accessGroup,
//        createdAt: createdAt,
//        modifiedAt: modifiedAt,
//        description: description,
//        type: type?.trimZero(),
//        label: label,
//        gerneic: generic,
//        isSynchronizable: .init(isSynchronizable)
//      )
//    }
}
