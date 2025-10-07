//
//  Synchronizable.swift
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

#if canImport(Security)
  public import Security
#endif

/// An enumeration representing the synchronization status of a keychain item.
public enum Synchronizable: Sendable {
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
    public var cfValue: (any Sendable)? {
      switch self {
      case .any:
        return kSecAttrSynchronizableAny as String

      case .disabled:
        return false

      case .enabled:
        return true
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
