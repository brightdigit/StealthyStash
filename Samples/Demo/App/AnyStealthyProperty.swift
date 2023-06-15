import StealthyStash

extension AnyStealthyProperty {
  public var dataString: String {
    property.dataString
  }

  public init(builder: StealthyPropertyBuilder) throws {
    let propertyType = builder.secClass.propertyType
    let property = try propertyType.init(builder: builder)
    self.init(property: property)
  }
}
