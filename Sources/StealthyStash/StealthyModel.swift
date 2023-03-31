public protocol StealthyModel {
  associatedtype QueryBuilder: ModelQueryBuilder
    where QueryBuilder.StealthyModelType == Self
}
