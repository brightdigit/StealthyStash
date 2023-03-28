import Foundation

public enum Synchronizable {
  case enabled
  case disabled
  case any
}

extension Synchronizable {
  static let anyStringValue : String = kSecAttrSynchronizableAny as String
  
  init?(rawDictionaryValue: Any) {
    let booleanValue = rawDictionaryValue as? Bool
    let stringValue = rawDictionaryValue as? String
    switch (booleanValue, stringValue) {
    case (true, _):
      self = .enabled
    case (false, _):
      self = .disabled
    case (_, Self.anyStringValue):
      self = .any
    case (_, _):
      assertionFailure("Unknown value: \(rawDictionaryValue)")
      return nil
    }
  }
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

  public var cfValue: Any? {
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
