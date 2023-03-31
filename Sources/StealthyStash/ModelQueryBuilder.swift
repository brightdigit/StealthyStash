/// A protocol for building queries for a stealthy model.
public protocol ModelQueryBuilder {
  /// The type of query that this builder can create.
  associatedtype QueryType

  /// The type of stealthy model that this builder can create.
  associatedtype StealthyModelType: StealthyModel

  /// Creates a dictionary of queries from a given query object.
  ///
  /// - Parameter query: The query object to convert to a dictionary of queries.
  ///
  /// - Returns: A dictionary of queries.
  static func queries(from query: QueryType) -> [String: Query]

  /// Creates a stealthy model from a dictionary of properties.
  ///
  /// - Parameter properties: A dictionary of properties to use to create the model.
  ///
  /// - Throws: An error if the model cannot be created from the given properties.
  ///
  /// - Returns: A new instance of the stealthy model.
  static func model(from properties: [String: [AnyStealthyProperty]])
    throws -> StealthyModelType?

  /// Extracts the properties of a stealthy model for a given operation.
  ///
  /// - Parameters:
  ///   - model: The model to extract properties from.
  ///   - operation: The operation to extract properties for.
  ///
  /// - Returns: An array of properties for the given operation.
  static func properties(
    from model: StealthyModelType,
    for operation: ModelOperation
  ) -> [AnyStealthyProperty]

  /// Creates an array of property updates from two versions of a stealthy model.
  ///
  /// - Parameters:
  ///   - previousItem: The previous version of the model.
  ///   - newItem: The new version of the model.
  ///
  /// - Returns: An array of property updates.
  static func updates(
    from previousItem: StealthyModelType,
    to newItem: StealthyModelType
  ) -> [StealthyPropertyUpdate]
}
