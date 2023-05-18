import Foundation

#if canImport(Security)
  import Security
#endif

extension InternetPasswordItem {
  /// The type of the property.
  public static let propertyType: StealthyPropertyType = .internet

  /// The unique identifier for the property.
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

  #if canImport(Security)
    /// Initializes a new instance of the property from a dictionary
    /// which contains all the required values.
    public init(dictionary: StealthyDictionary) throws {
      let common: CommonAttributes = try .init(dictionary: dictionary, isRaw: false)
      let server: String? = try dictionary.requireOptional(kSecAttrServer)
      let protocolString: CFString? = try dictionary.requireOptional(kSecAttrProtocol)
      let `protocol` = protocolString.flatMap(ServerProtocol.init(number:))
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

    /// Initializes a new instance of the property from a dictionary
    /// which may not contain all the required values.
    public init(rawDictionary: StealthyDictionary) throws {
      let common: CommonAttributes = try .init(dictionary: rawDictionary, isRaw: true)
      let server: String? = try rawDictionary.requireOptional(kSecAttrServer)
      let protocolString: CFString? = try rawDictionary.requireOptional(kSecAttrProtocol)
      let `protocol` = protocolString.flatMap(ServerProtocol.init(number:))
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

    internal init(
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
        comment: common.comment,
        type: common.type,
        label: common.label,
        server: server,
        protocol: `protocol`,
        port: port?.trimZero(),
        path: path,
        isSynchronizable: common.isSynchronizable
      )
    }

    /// Returns a dictionary of unique attributes for fetching property.
    public func uniqueAttributes() -> StealthyDictionary {
      [
        kSecAttrAccount as String: account,
        kSecAttrAccessGroup as String: accessGroup,
        kSecAttrServer as String: server,
        kSecAttrProtocol as String: self.protocol?.cfValue,
        kSecAttrPort as String: port,
        kSecAttrPath as String: path
      ]
    }

    /// Returns a dictionary of other properties for updating or creating the property.
    public func otherProperties() -> StealthyDictionary {
      [
        kSecAttrSynchronizable as String: isSynchronizable.cfValue,
        kSecAttrDescription as String: description,
        kSecAttrType as String: type,
        kSecAttrLabel as String: label
      ]
    }
  #endif
}
