import Foundation
import os

private enum StealthyRepositoryDefaultLogger {
  static let logger = Bundle.main.bundleIdentifier.map {
    Logger(subsystem: $0, category: "secrets")
  }
}

public protocol StealthyRepository {
  var logger: Logger? { get }
  func create(_ item: AnyStealthyProperty) throws
  func update<StealthyPropertyType: StealthyProperty>(
    _ item: StealthyPropertyType,
    from previousItem: StealthyPropertyType
  ) throws
  func delete(_ item: AnyStealthyProperty) throws
  func query(_ query: Query) throws -> [AnyStealthyProperty]
}

extension StealthyRepository {
  public var logger: Logger? {
    StealthyRepositoryDefaultLogger.logger
  }

  public func upsert(
    from previousAnyItem: AnyStealthyProperty?,
    to newItem: any StealthyProperty
  ) throws {
    try upsert(previousAnyItem, to: newItem)
  }

  public func upsert<StealthyPropertyType: StealthyProperty>(
    _ previousAnyItem: AnyStealthyProperty?,
    to newItem: StealthyPropertyType
  ) throws {
    let previousItem = previousAnyItem?.property as? StealthyPropertyType
    if let previousItem {
      try update(newItem, from: previousItem)
    } else {
      try create(AnyStealthyProperty(property: newItem))
    }
  }

  internal func deleteAll(basedOn queries: [Query]) throws {
    let properties = try queries.flatMap(query(_:))
    try properties.forEach(delete(_:))
  }

  public func clearAll() throws {
    try deleteAll(basedOn: [TypeQuery(type: .internet), TypeQuery(type: .generic)])
  }
}
