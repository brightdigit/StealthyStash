public struct SecretPropertyUpdate {
  public init(previousProperty: AnySecretProperty?, newProperty: AnySecretProperty?) {
    self.previousProperty = previousProperty
    self.newProperty = newProperty
  }

  let previousProperty: AnySecretProperty?
  let newProperty: AnySecretProperty?
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
