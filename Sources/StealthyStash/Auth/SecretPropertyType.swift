import Foundation

public enum SecretPropertyType {
  case internet
  case generic
}

extension SecretPropertyType {
  var secClass: CFString {
    switch self {
    case .internet:
      return kSecClassInternetPassword

    case .generic:
      return kSecClassGenericPassword
    }
  }

//  init?(secClass: CFString) {
//    switch secClass {
//    case kSecClassGenericPassword:
//      self = .generic
//
//    case kSecClassInternetPassword:
//      self = .internet
//
//    default:
//      return nil
//    }
//  }

  var propertyType: any SecretProperty.Type {
    switch self {
    case .internet:
      return InternetPasswordItem.self

    case .generic:
      return GenericPasswordItem.self
    }
  }
}
