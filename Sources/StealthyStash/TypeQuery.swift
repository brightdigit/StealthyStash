import Security

public struct TypeQuery: Query {
  public init(type: SecretPropertyType) {
    self.type = type
  }

  public let type: SecretPropertyType
}
