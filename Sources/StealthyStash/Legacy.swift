import Combine
import Foundation

struct LegacyPreviewRepository: LegacyCredentialRepository {
  init() {}
  func addItem(_: LegacyCredentialItem) {}
}

@available(*, deprecated)
protocol LegacyCredentialRepository {
  func addItem(_ item: LegacyCredentialItem) throws
}

struct LegacyCreditialItemBuilder {
  init(itemClass: LegacyItemClass = .generic, dataString: String = "", account: String = "", type: Int = 0, containsType: Bool = false, label: String = "", containsLabel: Bool = false) {
    self.itemClass = itemClass
    self.dataString = dataString
    self.account = account
    self.type = type
    self.containsType = containsType
    self.label = label
    self.containsLabel = containsLabel
  }

  var itemClass: LegacyItemClass = .generic
  var dataString: String = ""
  var account: String = ""
  var type: Int = 0
  var containsType: Bool = false
  var label: String = ""
  var containsLabel: Bool = false
}

struct LegacyCredentialItem {
  init(itemClass: LegacyItemClass, data: Data, account: String, type: Int? = nil, label: String? = nil, isSynchronizable: Bool? = nil) {
    self.itemClass = itemClass
    self.data = data
    self.account = account
    self.type = type
    self.label = label
    serviceName = nil
    server = nil
    accessGroup = nil
    self.isSynchronizable = isSynchronizable
  }

  let itemClass: LegacyItemClass
  let data: Data
  let account: String
  let type: Int?
  let label: String?
  let serviceName: String?
  let server: String?
  let accessGroup: String?
  let isSynchronizable: Bool?
}

extension LegacyCredentialItem {
  init(builder: LegacyCreditialItemBuilder) {
    guard let data = builder.dataString.data(
      using: .utf8,
      allowLossyConversion: false
    ) else {
      preconditionFailure("Can't extract data from string: \(builder.dataString)")
    }
    self.init(itemClass: builder.itemClass, data: data, account: builder.account,
              type: builder.containsType ? builder.type : nil,
              label: builder.containsLabel ? builder.label : nil)
  }
}

@available(*, deprecated)
class LegacyAddItemObject: ObservableObject {
  init(repository: LegacyCredentialRepository, item: LegacyCreditialItemBuilder = LegacyCreditialItemBuilder(), lastError: KeychainError? = nil) {
    self.repository = repository
    self.item = item
    self.lastError = lastError

    let itemAddResult = triggerAddSubject
      .map { self.item }
      .map(LegacyCredentialItem.init(builder:))
      .map { item in
        Result {
          try self.repository.addItem(item)
        }
      }.share()

    itemAddResult.compactMap { try? $0.get() }.map {
      LegacyCreditialItemBuilder()
    }.assign(to: &$item)

    itemAddResult.compactMap { result -> KeychainError? in
      guard case let .failure(error as KeychainError) = result else {
        return nil
      }

      return error
    }.map { $0 as KeychainError? }
      .assign(to: &$lastError)
  }

  let repository: LegacyCredentialRepository

  @Published var item = LegacyCreditialItemBuilder()
  let triggerAddSubject = PassthroughSubject<Void, Never>()
  @Published var lastError: KeychainError?

  func addItem() {
    triggerAddSubject.send()
  }
}

@available(*, deprecated)
enum LegacyItemClass: Int, CaseIterable, CustomStringConvertible, Identifiable, Hashable {
  var id: Int {
    rawValue
  }

  case generic
  case internet

  var description: String {
    switch self {
    case .generic:
      return "Generic"
    case .internet:
      return "Internet"
    }
  }

  var classValue: CFString {
    switch self {
    case .generic:
      return kSecClassGenericPassword

    case .internet:
      return kSecClassInternetPassword
    }
  }
}
