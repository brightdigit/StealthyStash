public protocol ModelQueryBuilder {
  associatedtype QueryType
  associatedtype StealthyModelType: StealthyModel

  static func queries(from query: QueryType) -> [String: Query]

  static func model(from properties: [String: [AnyStealthyProperty]])
    throws -> StealthyModelType?

  static func properties(
    from model: StealthyModelType,
    for operation: ModelOperation
  ) -> [AnyStealthyProperty]

  static func updates(
    from previousItem: StealthyModelType,
    to newItem: StealthyModelType
  ) -> [StealthyPropertyUpdate]
}
