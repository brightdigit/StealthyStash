import Foundation

public protocol SecretProperty: Identifiable, Hashable {
  static var propertyType: SecretPropertyType { get }

  var id: String { get }
  var account: String { get }
  var data: Data { get }

  var accessGroup: String? { get }
  var createdAt: Date? { get }
  var modifiedAt: Date? { get }
  var description: String? { get }
  var comment: String? { get }
  var type: Int? { get }
  var label: String? { get }
  var isSynchronizable: Synchronizable { get }

  init(dictionary: SecretDictionary) throws
  init(rawDictionary: SecretDictionary) throws

  func addQuery() -> SecretDictionary
  func deleteQuery() -> SecretDictionary
  func updateQuerySet() -> UpdateQuerySet

  func uniqueAttributes() -> SecretDictionary
  func otherProperties() -> SecretDictionary
}
