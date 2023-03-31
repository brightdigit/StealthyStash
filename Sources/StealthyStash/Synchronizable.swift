import Foundation

public enum Synchronizable {
  case enabled
  case disabled
  case any
}

extension Synchronizable {
  init(_ value: Int?) {
    switch value {
    case 0:
      self = .disabled

    case 1:
      self = .enabled

    case .none:
      self = .any

    case let .some(value):
      assertionFailure("Unknown value: \(value)")
      self = .any
    }
  }

  var cfValue: Any? {
    switch self {
    case .any:
      return kSecAttrSynchronizableAny

    case .disabled:
      return kCFBooleanFalse

    case .enabled:
      return kCFBooleanTrue
    }
  }
}
