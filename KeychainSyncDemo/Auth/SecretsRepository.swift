import os
import Foundation

protocol SecretsRepository {
  var logger : Logger? { get }
  func create(_ item: AnySecretProperty) throws
  func update<SecretPropertyType: SecretProperty>(_ item: SecretPropertyType, from previousItem: SecretPropertyType) throws
  func delete(_ item: AnySecretProperty) throws
  func query(_ query: Query) throws -> [AnySecretProperty]
}

enum SecretsRepositoryDefaultLogger {
  fileprivate static let logger = Bundle.main.bundleIdentifier.map{Logger(subsystem: $0, category: "secrets")}
}

extension SecretsRepository {
  public var logger : Logger? {
    return SecretsRepositoryDefaultLogger.logger
  }
  func upsert(from previousAnyItem: AnySecretProperty?, to newItem: any SecretProperty) throws {
    try self.upsert(previousAnyItem, to: newItem)
  }
  
  func upsert<SecretPropertyType : SecretProperty>(_ previousAnyItem: AnySecretProperty?, to newItem: SecretPropertyType) throws {
    let previousItem : SecretPropertyType? = previousAnyItem?.property as? SecretPropertyType
    if let previousItem {
      try self.update(newItem, from: previousItem)
    } else {
      try self.create(AnySecretProperty(property: newItem))
    }
  }
}
