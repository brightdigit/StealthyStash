/// A protocol for building queries for a ``StealthyModel``
public protocol ModelQueryBuilder {
  /// The type of query that this builder can create.
  associatedtype QueryType

  /// The type of ``StealthyModel`` that this builder can create.
  associatedtype StealthyModelType: StealthyModel

  /// Creates a dictionary of queries from a given query object.
  ///
  /// - Parameter query: The query object to convert to a dictionary of queries.
  ///
  /// - Returns: A dictionary of queries.
  static func queries(from query: QueryType) -> [String: any Query]

  /// Creates a ``StealthyModel``  from a dictionary of properties.
  ///
  /// - Parameter properties: A dictionary of properties to use to create the model.
  ///
  /// - Throws: An error if the model cannot be created from the given properties.
  ///
  /// - Returns: A new instance of the ``StealthyModel``.
  static func model(from properties: [String: [AnyStealthyProperty]])
    throws -> StealthyModelType?

  /// Extracts the properties of a ``StealthyModel`` for a given operation.
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

  /// Creates an array of property updates from two versions of a ``StealthyModel``.
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
