
protocol SecretModel {
  associatedtype QueryBuilder : ModelQueryBuilder where QueryBuilder.SecretModelType == Self
}
