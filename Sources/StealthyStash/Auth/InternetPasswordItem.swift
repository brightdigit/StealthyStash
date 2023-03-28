import Foundation
import Security

public struct InternetPasswordItem: Identifiable, Hashable, SecretProperty {
  public let account: String
  public let data: Data

  public let accessGroup: String?
  public let createdAt: Date?
  public let modifiedAt: Date?
  public let description: String?
  public let comment: String?
  public let type: Int?
  public let label: String?
  public let server: String?
  public let `protocol`: ServerProtocol?
  public let authenticationType: AuthenticationType?
  public let port: Int?
  public let path: String?
  public let isSynchronizable: Synchronizable

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
