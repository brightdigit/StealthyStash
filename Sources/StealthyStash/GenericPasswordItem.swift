import Foundation
import Security

public struct GenericPasswordItem: Identifiable, Hashable, StealthyProperty {
  public let account: String
  public let data: Data
  public let service: String?
  public let accessGroup: String?
  public let createdAt: Date?
  public let modifiedAt: Date?
  public let description: String?
  public let comment: String?
  public let type: Int?
  public let label: String?
  public let gerneic: Data?
  public let isSynchronizable: Synchronizable

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
    gerneic: Data? = nil,
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
    self.gerneic = gerneic
    self.isSynchronizable = isSynchronizable
  }
}
