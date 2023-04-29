#if canImport(os)
  import os
#else
  import Logging
#endif

import Foundation

/// A default logger for the `StealthyRepository` protocol.
private enum StealthyRepositoryDefaultLogger {
  #if canImport(os)
    static let logger = Bundle.main.bundleIdentifier.map {
      Logger(subsystem: $0, category: "secrets")
    }
  #else
    static let logger = Bundle.main.bundleIdentifier.map {
      Logger(label: $0)
    }
  #endif
}

/// A protocol for a repository that stores and retrieves `StealthyProperty` objects.
public protocol StealthyRepository {
  /// A logger for the repository.
  var logger: Logger? { get }

  /// Creates a new `StealthyProperty` object in the repository.
  func create(_ item: AnyStealthyProperty) throws

  /// Updates an existing `StealthyProperty` object in the repository.
  func update<StealthyPropertyType: StealthyProperty>(
    _ item: StealthyPropertyType,
    from previousItem: StealthyPropertyType
  ) throws

  /// Deletes a `StealthyProperty` object from the repository.
  func delete(_ item: AnyStealthyProperty) throws

  /// Queries the repository for `StealthyProperty` objects.
  func query(_ query: Query) throws -> [AnyStealthyProperty]
}

extension StealthyRepository {
  internal static var defaultLogger: Logger? {
    StealthyRepositoryDefaultLogger.logger
  }

  /// A default logger for the `StealthyRepository` protocol.
  public var logger: Logger? {
    Self.defaultLogger
  }

  /// Updates or creates a `StealthyProperty` object in the repository.
  public func upsert(
    from previousAnyItem: AnyStealthyProperty?,
    to newItem: any StealthyProperty
  ) throws {
    try upsert(previousAnyItem, to: newItem)
  }

  /// Updates or creates a `StealthyProperty` object in the repository.
  public func upsert<StealthyPropertyType: StealthyProperty>(
    _ previousAnyItem: AnyStealthyProperty?,
    to newItem: StealthyPropertyType
  ) throws {
    let previousItem = previousAnyItem?.property as? StealthyPropertyType
    if let previousItem = previousItem {
      try update(newItem, from: previousItem)
    } else {
      try create(AnyStealthyProperty(property: newItem))
    }
  }

  /// Deletes all `StealthyProperty` objects that match the given queries.
  internal func deleteAll(basedOn queries: [Query]) throws {
    let properties = try queries.flatMap(query(_:))
    try properties.forEach(delete(_:))
  }

  /// Deletes all `StealthyProperty` objects from the repository.
  public func clearAll() throws {
    try deleteAll(basedOn: [TypeQuery(type: .internet), TypeQuery(type: .generic)])
  }
}
