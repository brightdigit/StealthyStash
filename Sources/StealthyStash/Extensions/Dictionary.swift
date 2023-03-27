import Foundation
import Security
extension Dictionary {
  enum MissingValueError<Output>: Error {
    case missingKey(Key)
    case mismatchType(Value)
  }

  func requireOptionalCF<Output>(_ key: CFString) throws -> Output? where Key == String {
    guard let cfString: CFNumber = try requireOptional(key as String) else {
      return nil
    }
    let value = cfString as? Output
    return value
  }

  func requireOptional<Output>(_ key: CFString) throws -> Output? where Key == String {
    try requireOptional(key as String)
  }

  func requireOptional<Output>(_ key: Key) throws -> Output? {
    try requireOptional(key, as: Output.self)
  }

  private func requireOptional<Output>(_ key: Key, as _: Output.Type) throws -> Output? {
    guard let value = self[key] else {
      return nil
    }
    guard let value = value as? Output else {
      throw MissingValueError<Output>.mismatchType(value)
    }
    return value
  }

  func require<Output>(_ key: Key) throws -> Output {
    try require(key, as: Output.self)
  }

  func require<Output>(_ key: CFString) throws -> Output where Key == String {
    try require(key as String)
  }

  private func require<Output>(_ key: Key, as _: Output.Type) throws -> Output {
    guard let value = self[key] else {
      throw MissingValueError<Output>.missingKey(key)
    }
    guard let value = value as? Output else {
      throw MissingValueError<Output>.mismatchType(value)
    }
    return value
  }
}

extension Dictionary where Key == String, Value == Any? {
  func loggingDescription() -> String {
    compactMap { (key: String, value: Any?) in
      guard let value = value._deepUnwrapped else {
        // assertionFailure()
        return nil
      }

      return [key, "\(value)"].joined(separator: ": ")
    }.joined(separator: ", ")
  }

  func asCFDictionary() -> CFDictionary {
    compactMapValues { $0 } as CFDictionary
  }
}

extension Dictionary where Key == String, Value == Any {
  func loggingDescription() -> String {
    var values = [Key: Value]()
    if let data = self[kSecValueData as String] as? Data {
      values["data_string"] = String(bytes: data, encoding: .utf8)
    }
    return merging(with: values, overwrite: false)
      .compactMap { (key: String, value: Any?) in
        guard let value = value._deepUnwrapped else {
          assertionFailure()
          return nil
        }

        return [key, "\(value)"].joined(separator: ": ")
      }.joined(separator: ", ")
  }
}

extension Dictionary {
  fileprivate typealias DeepUnwrappable = _OptionalProtocol

  static func deepUnwrap(_ any: Any) -> Any? {
    if let optional = any as? _OptionalProtocol {
      return optional._deepUnwrapped
    }
    return any
  }

  func merging(with rhs: Self, overwrite: Bool) -> Self {
    merging(rhs) { lhs, rhs in
      let value = overwrite ? rhs : lhs
      return value
    }
  }

  internal func deepCompactMapValues() -> Self where Value == Any? {
    compactMapValues { $0 }.compactMapValues(Self.deepUnwrap).compactMapValues { $0 }
  }
}

private protocol _OptionalProtocol {
  var _deepUnwrapped: Any? { get }
}

extension Optional: Dictionary.DeepUnwrappable {
  fileprivate var _deepUnwrapped: Any? {
    if let wrapped = self { return [String: Any?].deepUnwrap(wrapped) }
    return nil
  }
}
