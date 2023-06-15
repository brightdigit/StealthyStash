import Foundation
import StealthyStash
extension InternetPasswordItem {
  public init(
    account: String,
    data: Data,
    accessGroup: String? = nil,
    url: URL? = nil,
    createdAt: Date? = nil,
    modifiedAt: Date? = nil,
    description: String? = nil,
    comment: String? = nil,
    type: Int? = nil,
    label: String? = nil,
    authenticationType _: AuthenticationType? = nil,
    isSynchronizable: Synchronizable = .any
  ) {
    self.init(
      account: account,
      data: data,
      accessGroup: accessGroup,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      description: description,
      comment: comment,
      type: type?.trimZero(),
      label: label,
      server: url?.host,
      protocol: url.flatMap(\.scheme).flatMap(ServerProtocol.init(scheme:)),
      port: url?.port?.trimZero(),
      path: url?.path,
      isSynchronizable: isSynchronizable
    )
  }

  static func random() -> InternetPasswordItem {
    let entry = SampleEntry.all.randomElement()!
    return InternetPasswordItem(
      account: entry.username,
      data: entry.password.data(using: .utf8)!,
      url: .random(),
      type: .random(in: 1 ... 12),
      label: UUID().uuidString
    )
  }
}
