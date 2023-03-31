import Security

public struct KeychainRepository: SecretsRepository {
  private let defaultProvider: DefaultProvider

  public init(defaultProvider: DefaultProvider) {
    self.defaultProvider = defaultProvider
  }

  private static func itemsFromQuery(
    dictionary: [String: Any?]
  ) throws -> [SecretDictionary] {
    var item: CFTypeRef?

    let status = SecItemCopyMatching(dictionary as CFDictionary, &item)

    guard status != errSecItemNotFound else {
      return []
    }
    guard
      let itemDictionaries = item as? [SecretDictionary],
      status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
    return itemDictionaries
  }

  public func create(_ item: AnySecretProperty) throws {
    let itemDictionary = item.property.addQuery()

    let query = itemDictionary
      .merging(defaultProvider.attributesForNewItem(ofType: item.propertyType)) {
        $0 ?? $1
      }
      .deepCompactMapValues()

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

    logger?.debug("Deleting: \(deleteQuery.loggingDescription())")
    let status = SecItemDelete(deleteQuery.asCFDictionary())

    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
  }

  public func query(_ query: Query) throws -> [AnySecretProperty] {
    let defaultAttributes = defaultProvider.attributesForQuery(ofType: query.type)
    let dictionaryAny = query
      .keychainDictionary()
      .merging(with: defaultAttributes, overwrite: false)

    let cfQuery = dictionaryAny.deepCompactMapValues()

    logger?.debug("Query: \(cfQuery.loggingDescription())")

    let dictionaries = try Self.itemsFromQuery(dictionary: cfQuery)

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
}

extension KeychainRepository {
  public init(
    defaultServiceName: String,
    defaultServerName: String,
    defaultAccessGroup: String? = nil,
    defaultSynchronizable: Synchronizable = .any
  ) {
    let provider = SimpleDefaultProvider(
      defaultServiceName: defaultServiceName,
      defaultServerName: defaultServerName,
      defaultAccessGroup: defaultAccessGroup,
      defaultSynchronizable: defaultSynchronizable
    )
    self.init(defaultProvider: provider)
  }
}
