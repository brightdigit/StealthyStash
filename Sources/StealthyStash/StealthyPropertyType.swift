import Foundation

/// An enumeration of property types that can be stored securely.
public enum StealthyPropertyType {
  /// An internet password.
  case internet

  /// A generic password.
  case generic
}

extension StealthyPropertyType {
  #if canImport(Security)
    /// The security class for the property type.
    public var secClass: CFString {
      switch self {
      case .internet:
        return kSecClassInternetPassword

      case .generic:
        return kSecClassGenericPassword
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
