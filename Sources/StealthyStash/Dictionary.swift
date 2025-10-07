//
//  Dictionary.swift
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

private protocol OptionalProtocol {
  var deepUnwrapped: (any Sendable)? { get }
}

extension Dictionary where Key: Sendable, Value: Sendable {
  internal enum MissingValueError: Error {
    case missingKey(Key)
    case mismatchType(Value)
  }

  internal static func deepUnwrap(_ any: (any Sendable)?) -> (any Sendable)? {
    if let optional = any as? (any OptionalProtocol) {
      return optional.deepUnwrapped
    }
    return any
  }

  internal func merging(with rhs: Self, overwrite: Bool) -> Self {
    merging(rhs) { lhs, rhs in
      let value = overwrite ? rhs : lhs
      return value
    }
  }

  internal func deepCompactMapValues() -> Self where Value == (any Sendable)? {
    compactMapValues { $0 }.compactMapValues(Self.deepUnwrap).compactMapValues { $0 }
  }

  #if canImport(Security)
    internal func requireOptionalCF<Output>(
      _ key: CFString
    ) throws -> Output? where Key == String {
      guard let cfString: CFNumber = try requireOptional(key as String) else {
        return nil
      }
      let value = cfString as? Output
      return value
    }

    internal func requireOptional<Output>(
      _ key: CFString
    ) throws -> Output? where Key == String {
      try requireOptional(key as String)
    }

    internal func require<Output>(_ key: CFString) throws -> Output where Key == String {
      try require(key as String)
    }
  #endif

  internal func requireOptional<Output>(_ key: Key) throws -> Output? {
    try requireOptional(key, as: Output.self)
  }

  private func requireOptional<Output>(_ key: Key, as _: Output.Type) throws -> Output? {
    guard let value = self[key] else {
      return nil
    }
    guard let value = value as? Output else {
      throw MissingValueError.mismatchType(value)
    }
    return value
  }

  internal func require<Output>(_ key: Key) throws -> Output {
    try require(key, as: Output.self)
  }

  private func require<Output>(_ key: Key, as _: Output.Type) throws -> Output {
    guard let value = self[key] else {
      throw MissingValueError.missingKey(key)
    }
    guard let value = value as? Output else {
      throw MissingValueError.mismatchType(value)
    }
    return value
  }
}

extension Dictionary where Key == String, Value == (any Sendable)? {
  internal func loggingDescription() -> String {
    compactMap { (key: String, value: (any Sendable)?) in
      guard let value = value.deepUnwrapped else {
        // assertionFailure()
        return nil
      }

      return [key, "\(value)"].joined(separator: ": ")
    }.joined(separator: ", ")
  }

  #if canImport(Security)
    internal func asCFDictionary() -> CFDictionary {
      compactMapValues { $0 } as CFDictionary
    }
  #endif
}

extension Optional: OptionalProtocol {
  fileprivate var deepUnwrapped: (any Sendable)? {
    guard let wrapped = self else {
      return nil
    }

    // Since we can't safely cast to Sendable in all cases, we'll handle common types
    switch wrapped {
    case let string as String:
      return StealthyDictionary.deepUnwrap(string)

    case let int as Int:
      return StealthyDictionary.deepUnwrap(int)

    case let bool as Bool:
      return StealthyDictionary.deepUnwrap(bool)

    case let data as Data:
      return StealthyDictionary.deepUnwrap(data)

    case let date as Date:
      return StealthyDictionary.deepUnwrap(date)

    default:
      // For unknown types, convert to string
      return "\(wrapped)"
    }
  }
}
