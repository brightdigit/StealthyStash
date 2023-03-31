import Security

public struct TypeQuery: Query {
  public let type: SecretPropertyType

  public init(type: SecretPropertyType) {
    self.type = type
  }
}
