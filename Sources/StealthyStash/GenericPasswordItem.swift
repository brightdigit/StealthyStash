#if canImport(Security)
  public import Foundation
#else
  @preconcurrency import Foundation
#endif

/// A struct representing a generic password item.
public struct GenericPasswordItem: Identifiable, Hashable, StealthyProperty {
  /// The account name associated with the password.
  public let account: String

  /// The password data.
  public let data: Data

  /// The service associated with the password.
  public let service: String?

  /// The access group associated with the password.
  public let accessGroup: String?

  /// The creation date of the password.
  public let createdAt: Date?

  /// The modification date of the password.
  public let modifiedAt: Date?

  /// A description of the password.
  public let description: String?

  /// A comment associated with the password.
  public let comment: String?

  /// The type of the password.
  public let type: Int?

  /// The label of the password.
  public let label: String?

  /// The generic data associated with the password.
  public let generic: Data?

  /// Whether the password is synchronizable.
  public let isSynchronizable: Synchronizable

  /// Initializes a new `GenericPasswordItem`.
  public init(
    account: String,
    data: Data,
    service: String? = nil,
    accessGroup: String? = nil,
    createdAt: Date? = nil,
    modifiedAt: Date? = nil,
    description: String? = nil,
    comment: String? = nil,
    type: Int? = nil,
    label: String? = nil,
    generic: Data? = nil,
    isSynchronizable: Synchronizable = .any
  ) {
    self.account = account
    self.data = data
    self.service = service
    self.accessGroup = accessGroup
    self.createdAt = createdAt
    self.modifiedAt = modifiedAt
    self.description = description
    self.comment = comment
    self.type = type
    self.label = label
    self.generic = generic
    self.isSynchronizable = isSynchronizable
  }
}
