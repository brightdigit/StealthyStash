import Foundation

#if canImport(Security)
  import Security
#endif

/// An enumeration representing the synchronization status of a keychain item.
public enum Synchronizable {
  /// The item is synchronized with other devices.
  case enabled

  /// The item is not synchronized with other devices.
  case disabled

  /// The item can be synchronized or not, depending on the context.
  case any
}

extension Synchronizable {
  #if canImport(Security)
    private static let anyStringValue: String = kSecAttrSynchronizableAny as String

    /// The Core Foundation value corresponding to the enumeration case.
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

    /// Creates an instance of `Synchronizable` from a raw dictionary value.
    ///
    /// - Parameter rawDictionaryValue: The raw value to convert.
    internal init?(rawDictionaryValue: Any) {
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
  #endif

  /// Creates an instance of `Synchronizable` from an integer value.
  ///
  /// - Parameter value: The integer value to convert.
  internal init(_ value: Int?) {
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
}
