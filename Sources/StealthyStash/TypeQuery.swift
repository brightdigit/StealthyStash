import Security

public struct TypeQuery: Query {
  public let type: StealthyPropertyType

  public init(type: StealthyPropertyType) {
    self.type = type
  }
}
