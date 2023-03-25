import Foundation
import os

public protocol SecretsRepository {
  var logger: Logger? { get }
  func create(_ item: AnySecretProperty) throws
  func update<SecretPropertyType: SecretProperty>(_ item: SecretPropertyType, from previousItem: SecretPropertyType) throws
  func delete(_ item: AnySecretProperty) throws
  func query(_ query: Query) throws -> [AnySecretProperty]
}

enum SecretsRepositoryDefaultLogger {
  fileprivate static let logger = Bundle.main.bundleIdentifier.map { Logger(subsystem: $0, category: "secrets") }
}

extension SecretsRepository {
  public var logger: Logger? {
    SecretsRepositoryDefaultLogger.logger
  }

  public func upsert(from previousAnyItem: AnySecretProperty?, to newItem: any SecretProperty) throws {
    try upsert(previousAnyItem, to: newItem)
  }

  public func upsert<SecretPropertyType: SecretProperty>(_ previousAnyItem: AnySecretProperty?, to newItem: SecretPropertyType) throws {
    let previousItem: SecretPropertyType? = previousAnyItem?.property as? SecretPropertyType
    if let previousItem {
      try update(newItem, from: previousItem)
    } else {
      try create(AnySecretProperty(property: newItem))
    }
  }

  func deleteAll(basedOn queries: [Query]) throws {
    let properties = try queries.flatMap(query(_:))
    try properties.forEach(delete(_:))
  }

  public func clearAll() throws {
    try deleteAll(basedOn: [TypeQuery(type: .internet), TypeQuery(type: .generic)])
  }
}
