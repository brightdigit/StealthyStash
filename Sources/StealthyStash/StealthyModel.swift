/// A protocol for models that can be used with a ``ModelQueryBuilder``.
public protocol StealthyModel {
  var account : String { get }
  /// The type of ``ModelQueryBuilder`` that can be used with this model.
  associatedtype QueryBuilder: ModelQueryBuilder
    where QueryBuilder.StealthyModelType == Self
}
