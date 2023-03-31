import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

#if canImport(Darwin)
  import Darwin
#else
  public typealias OSStatus = Int32
#endif

public enum KeychainError: Error, LocalizedError, Equatable {
  case unexpectedPasswordData
  case noPassword
  case unhandledError(status: OSStatus)

  case unsupportedClass(String)

  public var errorDescription: String? {
    switch self {
    case .unexpectedPasswordData:
      return "unexpectedPasswordData"
    case .noPassword:
      return "noPassword"
    case let .unhandledError(status: status):
      if let description = SecCopyErrorMessageString(status, nil) {
        return description as String
      } else {
        return "Status code: \(status)\n"
      }

    case let .unsupportedClass(className):
      return "Unsupported class: \(className)"
    }
  }
}
