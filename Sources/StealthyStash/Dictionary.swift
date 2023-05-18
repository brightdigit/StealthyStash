import Foundation

private protocol _OptionalProtocol {
  var _deepUnwrapped: Any? { get }
}

extension Dictionary {
  // swiftlint:disable:next strict_fileprivate
  fileprivate typealias DeepUnwrappable = _OptionalProtocol

  internal enum MissingValueError: Error {
    case missingKey(Key)
    case mismatchType(Value)
  }

  internal static func deepUnwrap(_ any: Any) -> Any? {
    if let optional = any as? _OptionalProtocol {
      return optional._deepUnwrapped
    }
    return any
  }

  internal func merging(with rhs: Self, overwrite: Bool) -> Self {
    merging(rhs) { lhs, rhs in
      let value = overwrite ? rhs : lhs
      return value
    }
  }

  internal func deepCompactMapValues() -> Self where Value == Any? {
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

extension Dictionary where Key == String, Value == Any? {
  internal func loggingDescription() -> String {
    compactMap { (key: String, value: Any?) in
      guard let value = value._deepUnwrapped else {
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

extension Optional: Dictionary.DeepUnwrappable {
  // swiftlint:disable:next strict_fileprivate
  fileprivate var _deepUnwrapped: Any? {
    if let wrapped = self {
      return StealthyDictionary.deepUnwrap(wrapped)
    }
    return nil
  }
}
