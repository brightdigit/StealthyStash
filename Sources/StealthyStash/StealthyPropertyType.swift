import Foundation

public enum StealthyPropertyType {
  case internet
  case generic
}

extension StealthyPropertyType {
  public var secClass: CFString {
    switch self {
    case .internet:
      return kSecClassInternetPassword

    case .generic:
      return kSecClassGenericPassword
    }
  }

  public var propertyType: any StealthyProperty.Type {
    switch self {
    case .internet:
      return InternetPasswordItem.self

    case .generic:
      return GenericPasswordItem.self
    }
  }
}
