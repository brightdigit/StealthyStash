public struct StealthyPropertyUpdate {
  internal let previousProperty: AnyStealthyProperty?
  internal let newProperty: AnyStealthyProperty?

  public init(previousProperty: AnyStealthyProperty?, newProperty: AnyStealthyProperty?) {
    self.previousProperty = previousProperty
    self.newProperty = newProperty
  }
}

extension StealthyPropertyUpdate {
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
