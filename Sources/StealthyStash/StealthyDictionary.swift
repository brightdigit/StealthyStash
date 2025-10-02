#if canImport(Security)
  public import Foundation
#else
  import Foundation
#endif

/// A dictionary with string keys and optional sendable values.
public typealias StealthyDictionary = [String: (any Sendable)?]
