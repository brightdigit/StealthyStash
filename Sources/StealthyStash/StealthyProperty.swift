import Foundation

public protocol StealthyProperty: Identifiable, Hashable {
  static var propertyType: StealthyPropertyType { get }

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

  init(dictionary: StealthyDictionary) throws
  init(rawDictionary: StealthyDictionary) throws

  func addQuery() -> StealthyDictionary
  func deleteQuery() -> StealthyDictionary
  func updateQuerySet() -> UpdateQuerySet

  func uniqueAttributes() -> StealthyDictionary
  func otherProperties() -> StealthyDictionary
}
