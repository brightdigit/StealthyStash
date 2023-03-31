public struct SecretPropertyUpdate {
  internal let previousProperty: AnySecretProperty?
  internal let newProperty: AnySecretProperty?

  public init(previousProperty: AnySecretProperty?, newProperty: AnySecretProperty?) {
    self.previousProperty = previousProperty
    self.newProperty = newProperty
  }
}

extension SecretPropertyUpdate {
  public init<SecretPropertyType: SecretProperty>(
    previousProperty: SecretPropertyType?,
    newProperty: SecretPropertyType?
  ) {
    self.init(
      previousProperty: previousProperty.map(AnySecretProperty.init(property:)),
      newProperty: newProperty.map(AnySecretProperty.init(property:))
    )
  }
}
