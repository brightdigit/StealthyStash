import Foundation

/// A protocol for properties that can be stored securely.
public protocol StealthyProperty: Identifiable, Hashable {
  /// The type of the property.
  static var propertyType: StealthyPropertyType { get }

  /// The unique identifier for the property.
  var id: String { get }

  /// The account associated with the property.
  var account: String { get }

  /// The data stored in the property.
  var data: Data { get }

  /// The access group for the property.
  var accessGroup: String? { get }

  /// The creation date of the property.
  var createdAt: Date? { get }

  /// The modification date of the property.
  var modifiedAt: Date? { get }

  /// A description of the property.
  var description: String? { get }

  /// A comment associated with the property.
  var comment: String? { get }

  /// The type value of the property.
  var type: Int? { get }

  /// The label of the property.
  var label: String? { get }

  /// Whether the property is synchronizable.
  var isSynchronizable: Synchronizable { get }

  #if canImport(Security)

    /// Initializes a new instance of the property from a dictionary
    /// which contains all the required values.
    init(dictionary: StealthyDictionary) throws

    /// Initializes a new instance of the property from a dictionary
    /// which may not contain all the required values.
    init(rawDictionary: StealthyDictionary) throws

    /// Returns a dictionary representing the property for adding to the database.
    func addQuery() -> StealthyDictionary

    /// Returns a dictionary representing the property for deleting from the database.
    func deleteQuery() -> StealthyDictionary

    /// Returns a dictionary representing the property for updating in the database.
    func updateQuerySet() -> UpdateQuerySet

    /// Returns a dictionary of unique attributes for fetching property.
    func uniqueAttributes() -> StealthyDictionary

    /// Returns a dictionary of other properties for updating or creating the property.
    func otherProperties() -> StealthyDictionary
  #endif
}
