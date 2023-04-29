/// A query for a specific type of security property.
public struct TypeQuery: Query {
  /// The type of security property to query.
  public let type: StealthyPropertyType

  /// Initializes a new `TypeQuery` instance.
  /// - Parameter type: The type of security property to query.
  public init(type: StealthyPropertyType) {
    self.type = type
  }
}
