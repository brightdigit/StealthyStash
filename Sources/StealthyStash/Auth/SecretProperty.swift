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
  var isSynchronizable: Bool? { get }

  func addQuery() -> SecretDictionary
  func deleteQuery() -> SecretDictionary
  func updateQuerySet() -> UpdateQuerySet

  func uniqueAttributes() -> SecretDictionary
  func otherProperties() -> SecretDictionary

  init(dictionary: [String: Any]) throws
  init(builder: SecretPropertyBuilder) throws
}

extension SecretProperty {
//  func castAsSameType(secretProperty: (any SecretProperty)?) -> Self? {
//    secretProperty as? Self
//  }
}
