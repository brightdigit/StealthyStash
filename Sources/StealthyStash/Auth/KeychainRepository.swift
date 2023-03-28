import Security

public struct KeychainRepository: SecretsRepository {
  public func create(_ item: AnySecretProperty) throws {
    let itemDictionary = item.property.addQuery()

    let query = itemDictionary.merging(defaultNewProperties(forType: item.propertyType)) {
      $0 ?? $1
    }.deepCompactMapValues()

    logger?.debug("Creating: \(query.loggingDescription())")

    let status = SecItemAdd(query as CFDictionary, nil)

    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
  }

  public func update<SecretPropertyType: SecretProperty>(
    _ item: SecretPropertyType,
    from previousItem: SecretPropertyType
  ) throws {
    let querySet = UpdateQuerySet(
      from: previousItem,
      to: item
    )
    .merging(
      with: defaultNewProperties(forType: SecretPropertyType.propertyType),
      overwrite: false
    )

    logger?.debug("Updating: \(querySet.query.loggingDescription())")
    logger?.debug(
      " To: \(querySet.attributes.deepCompactMapValues().loggingDescription())"
    )

    let status = SecItemUpdate(
      querySet.query.asCFDictionary(),
      querySet.attributes.asCFDictionary()
    )

    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
  }

  public func delete(_ item: AnySecretProperty) throws {
    let deleteQuery = item.property
      .deleteQuery()
      .deepCompactMapValues()
      .merging(with: defaultNewProperties(forType: item.propertyType), overwrite: false)

    logger?.debug("Deleting: \(deleteQuery.loggingDescription())")
    let status = SecItemDelete(deleteQuery.asCFDictionary())

    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
  }

  public func query(_ query: Query) throws -> [AnySecretProperty] {
    let dictionaryAny = [
      kSecClass as String: query.type.secClass,
      kSecAttrServer as String: query.type == .internet ? defaultServerName : nil,
      kSecAttrService as String: query.type == .generic ? defaultServiceName : nil,
      kSecReturnAttributes as String: true,
      kSecReturnData as String: true,
      kSecAttrAccessGroup as String: defaultAccessGroup,
      kSecAttrSynchronizable as String: kSecAttrSynchronizableAny,
      kSecMatchLimit as String: kSecMatchLimitAll
    ] as [String: Any?]

    var item: CFTypeRef?
    let cfQuery = dictionaryAny.deepCompactMapValues()

    logger?.debug("Query: \(cfQuery.loggingDescription())")

    let status = SecItemCopyMatching(cfQuery as CFDictionary, &item)

    guard status != errSecItemNotFound else {
      return []
    }
    guard let dictionaries = item as? [[String: Any]], status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }

    do {
      return try dictionaries.map {
        self.logger?.debug("Found Item: \($0.loggingDescription())")
        return $0
      }
      .map(query.type.propertyType.init(dictionary:))
      .map(AnySecretProperty.init(property:))
    } catch {
      assertionFailure(error.localizedDescription)
      return []
    }
  }

  public init(
    defaultServiceName: String,
    defaultServerName: String,
    defaultAccessGroup: String? = nil,
    defaultSynchronizable: Bool? = nil
  ) {
    self.defaultServiceName = defaultServiceName
    self.defaultServerName = defaultServerName
    self.defaultAccessGroup = defaultAccessGroup
    self.defaultSynchronizable = defaultSynchronizable
  }

  let defaultServiceName: String
  let defaultServerName: String
  let defaultAccessGroup: String?
  let defaultSynchronizable: Bool?

  func defaultNewProperties(forType type: SecretPropertyType) -> [String: Any?] {
    [
      kSecAttrService as String: type == .generic ? defaultServiceName : nil,
      kSecAttrServer as String: type == .internet ? defaultServerName : nil,
      kSecAttrAccessGroup as String: defaultAccessGroup,
      kSecAttrSynchronizable as String: defaultSynchronizable
    ]
  }
}
