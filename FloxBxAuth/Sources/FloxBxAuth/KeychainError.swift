import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

#if canImport(Darwin)
  import Darwin
#else
  public typealias OSStatus = Int32
#endif

internal enum KeychainError: Error {
  case unexpectedPasswordData
  case noPassword
  case unhandledError(status: OSStatus)
}
