#if swift(>=6.0)
public import Foundation
#else
import Foundation
#endif

/// An enumeration of property types that can be stored securely.
public enum StealthyPropertyType: Sendable {
  /// An internet password.
  case internet

  /// A generic password.
  case generic
}

extension StealthyPropertyType {
  #if canImport(Security)
    /// The security class for the property type.
    internal var secClass: String {
      switch self {
      case .internet:
        return kSecClassInternetPassword as String

      case .generic:
        return kSecClassGenericPassword as String
      }
    }
  #endif

  /// The type of property to use.
  public var propertyType: any StealthyProperty.Type {
    switch self {
    case .internet:
      return InternetPasswordItem.self

    case .generic:
      return GenericPasswordItem.self
    }
  }
}
