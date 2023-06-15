import Foundation

/// A struct representing an internet password item.
public struct InternetPasswordItem: Identifiable, Hashable, StealthyProperty {
  /// The account name associated with the password.
  public let account: String

  /// The password data.
  public let data: Data

  /// The access group for the password item.
  public let accessGroup: String?

  /// The creation date of the password item.
  public let createdAt: Date?

  /// The modification date of the password item.
  public let modifiedAt: Date?

  /// A description of the password item.
  public let description: String?

  /// A comment associated with the password item.
  public let comment: String?

  /// The type of the password item.
  public let type: Int?

  /// The label of the password item.
  public let label: String?

  /// The server associated with the password item.
  public let server: String?

  /// The protocol used by the server.
  public let `protocol`: ServerProtocol?

  /// The authentication type used by the server.
  public let authenticationType: AuthenticationType?

  /// The port used by the server.
  public let port: Int?

  /// The path of the server.
  public let path: String?

  /// Whether the password item is synchronizable.
  public let isSynchronizable: Synchronizable

  /// Initializes a new `InternetPasswordItem`.
  public init(
    account: String,
    data: Data,
    accessGroup: String? = nil,
    createdAt: Date? = nil,
    modifiedAt: Date? = nil,
    description: String? = nil,
    comment: String? = nil,
    type: Int? = nil,
    label: String? = nil,
    server: String? = nil,
    protocol: ServerProtocol? = nil,
    authenticationType: AuthenticationType? = nil,
    port: Int? = nil,
    path: String? = nil,
    isSynchronizable: Synchronizable = .any
  ) {
    self.account = account
    self.data = data
    self.accessGroup = accessGroup
    self.createdAt = createdAt
    self.modifiedAt = modifiedAt
    self.description = description
    self.comment = comment
    self.type = type
    self.label = label
    self.server = server
    self.protocol = `protocol`
    self.authenticationType = authenticationType
    self.port = port
    self.path = path
    self.isSynchronizable = isSynchronizable
  }
}
