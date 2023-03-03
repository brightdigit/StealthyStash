import CoreFoundation

extension Dictionary {
  enum MissingValueError<Output>: Error {
    case missingKey(Key)
    case mismatchType(Value)


    
  }

  func requireOptionalCF<Output>(_ key: CFString) throws -> Output? where Key == String {
    guard let cfString : CFNumber = try self.requireOptional(key as String) else {
      return nil
    }
    let value = cfString as? Output
    return value
  }
  
  func requireOptional<Output>(_ key: CFString) throws -> Output? where Key == String {
    try self.requireOptional(key as String)
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
  func asCFDictionary() -> CFDictionary {
    self.compactMapValues{$0} as CFDictionary
  }
}

extension Dictionary {
  func merging (with rhs: Self, overwrite : Bool) -> Self {
    self.merging(rhs) { lhs, rhs in
      overwrite ? rhs : lhs
    }
  }
}
