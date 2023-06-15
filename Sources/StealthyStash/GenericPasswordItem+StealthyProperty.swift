import Foundation
#if canImport(Security)

  import Security
#endif

extension GenericPasswordItem {
  /// The type of the property.
  public static var propertyType: StealthyPropertyType {
    .generic
  }

  /// The unique identifier for the property.
  public var id: String {
    [
      account,
      service
    ].compactMap { $0 }.joined()
  }

  #if canImport(Security)
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

    /// Initializes a new instance of the property from a dictionary
    /// which contains all the required values.
    public init(dictionary: StealthyDictionary) throws {
      let common: CommonAttributes = try .init(dictionary: dictionary, isRaw: false)
      let service: String = try dictionary.require(kSecAttrService)
      let generic: Data? = try dictionary.requireOptional(kSecAttrGeneric)
      self.init(
        common: common,
        service: service,
        generic: generic
      )
    }

    /// Initializes a new instance of the property from a dictionary
    /// which may not contain all the required values.
    public init(rawDictionary: StealthyDictionary) throws {
      let common: CommonAttributes = try .init(dictionary: rawDictionary, isRaw: true)
      let service: String? = try rawDictionary.requireOptional(kSecAttrService)
      let generic: Data? = try rawDictionary.requireOptional(kSecAttrGeneric)
      self.init(
        common: common,
        service: service,
        generic: generic
      )
    }

    /// Returns a dictionary of unique attributes for fetching property.
    public func uniqueAttributes() -> StealthyDictionary {
      [
        kSecAttrAccount as String: account,
        kSecAttrService as String: service,
        kSecAttrAccessGroup as String: accessGroup,
        kSecAttrSynchronizable as String: isSynchronizable.cfValue
      ]
    }

    /// Returns a dictionary of other properties for updating or creating the property.
    public func otherProperties() -> StealthyDictionary {
      [
        kSecAttrGeneric as String: gerneic,
        kSecAttrDescription as String: description,
        kSecAttrComment as String: comment,
        kSecAttrType as String: type,
        kSecAttrLabel as String: label
      ]
    }
  #endif
}
