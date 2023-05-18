import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

#if canImport(Darwin)
  import Darwin
#else
  // swiftlint:disable:next missing_docs
  public typealias OSStatus = Int32
  // swiftlint:disable:next identifier_name
  private func SecCopyErrorMessageString(_: OSStatus, _: Any?) -> String? {
    nil
  }
#endif

/// An error that can occur when interacting with the keychain.
public enum KeychainError: Error, LocalizedError, Equatable {
  /// The password data was not in the expected format.
  case unexpectedPasswordData

  /// No password was found.
  case noPassword

  /// An unhandled error occurred.
  case unhandledError(status: OSStatus)

  /// The class is not supported.
  case unsupportedClass(String)

  /// A localized description of the error.
  public var errorDescription: String? {
    switch self {
    case .unexpectedPasswordData:
      return "The password data was not in the expected format."
    case .noPassword:
      return "No password was found."
    case let .unhandledError(status: status):
      if let description = SecCopyErrorMessageString(status, nil) {
        return description as String
      } else {
        return "Unhandled error with status code: \(status)\n"
      }

    case let .unsupportedClass(className):
      return "Unsupported class: \(className)"
    }
  }
}
