//
//  KeychainError.swift
//  StealthyStash
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

public import Foundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

// swift-format-ignore: AllPublicDeclarationsHaveDocumentation, AlwaysUseLowerCamelCase
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
        return "Unhandled error with status code: \(status)"
      }

    case let .unsupportedClass(className):
      return "Unsupported class: \(className)"
    }
  }
}
