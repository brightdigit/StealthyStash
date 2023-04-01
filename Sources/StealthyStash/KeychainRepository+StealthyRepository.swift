import os
import Security

extension KeychainRepository {
  private static func itemsFromQuery(
    dictionary: [String: Any?]
  ) throws -> [StealthyDictionary] {
    var item: CFTypeRef?

    let status = SecItemCopyMatching(dictionary as CFDictionary, &item)

    guard status != errSecItemNotFound else {
      return []
    }
    guard
      let itemDictionaries = item as? [StealthyDictionary],
      status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
    return itemDictionaries
  }

  public func create(_ item: AnyStealthyProperty) throws {
    let defaults = defaultProvider?.attributesForNewItem(ofType: item.propertyType) ?? [:]
    let itemDictionary = item.property.addQuery()

    let query = itemDictionary
      .merging(defaults) {
        $0 ?? $1
      }
      .deepCompactMapValues()

    logger?.debug("Creating: \(query.loggingDescription())")

    let status = SecItemAdd(query as CFDictionary, nil)

    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
  }

  public func update<StealthyPropertyType: StealthyProperty>(
    _ item: StealthyPropertyType,
    from previousItem: StealthyPropertyType
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

  public func delete(_ item: AnyStealthyProperty) throws {
    let deleteQuery = item.property
      .deleteQuery()
      .deepCompactMapValues()

    logger?.debug("Deleting: \(deleteQuery.loggingDescription())")
    let status = SecItemDelete(deleteQuery.asCFDictionary())

    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
  }

  public func query(_ query: Query) throws -> [AnyStealthyProperty] {
    let defaults = defaultProvider?.attributesForQuery(ofType: query.type) ?? [:]
    let dictionaryAny = query
      .keychainDictionary()
      .merging(with: defaults, overwrite: false)

    let cfQuery = dictionaryAny.deepCompactMapValues()

    logger?.debug("Query: \(cfQuery.loggingDescription())")

    let dictionaries = try Self.itemsFromQuery(dictionary: cfQuery)

    do {
      return try dictionaries.map {
        self.logger?.debug("Found Item: \($0.loggingDescription())")
        return $0
      }
      .map(query.type.propertyType.init(dictionary:))
      .map(AnyStealthyProperty.init(property:))
    } catch {
      assertionFailure(error.localizedDescription)
      return []
    }
  }
}
