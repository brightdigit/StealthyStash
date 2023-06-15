/// A struct representing an update to a stealthy property.
public struct StealthyPropertyUpdate {
  /// The previous value of the property.
  internal let previousProperty: AnyStealthyProperty?

  /// The new value of the property.
  internal let newProperty: AnyStealthyProperty?

  ///
  /// Initializes a new `StealthyPropertyUpdate`.

  /// - Parameters:
  ///   - previousProperty: The previous value of the property.
  ///   - newProperty: The new value of the property.
  ///
  public init(previousProperty: AnyStealthyProperty?, newProperty: AnyStealthyProperty?) {
    self.previousProperty = previousProperty
    self.newProperty = newProperty
  }
}

extension StealthyPropertyUpdate {
  /// Initializes a new `StealthyPropertyUpdate`
  /// with a specific type of `StealthyProperty`.
  /// - Parameters:
  ///    - previousProperty: The previous value of the property.
  ///    - newProperty: The new value of the property.
  public init<StealthyPropertyType: StealthyProperty>(
    previousProperty: StealthyPropertyType?,
    newProperty: StealthyPropertyType?
  ) {
    self.init(
      previousProperty: previousProperty.map(AnyStealthyProperty.init(property:)),
      newProperty: newProperty.map(AnyStealthyProperty.init(property:))
    )
  }
}
