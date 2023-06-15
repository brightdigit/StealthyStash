import Foundation
import StealthyStash
extension GenericPasswordItem {
  static func random(withAccountName accountName: String? = nil) -> GenericPasswordItem {
    let entry: SampleEntry

    if let accountName {
      entry = SampleEntry.all.first { $0.username == accountName }!
    } else {
      entry = SampleEntry.all.randomElement()!
    }
    return GenericPasswordItem(
      account: entry.username,
      data: entry.token.data(using: .utf8)!,
      type: .random(in: 1 ... 12),
      label: UUID().uuidString
    )
  }
}
