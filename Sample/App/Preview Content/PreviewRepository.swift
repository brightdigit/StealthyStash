import StealthyStash

struct PreviewRepository: SecretsRepository {
  func delete(_: AnySecretProperty) throws {}

  let items: [AnySecretProperty]
  func create(_: AnySecretProperty) throws {}

  func update(_: AnySecretProperty) throws {}

  func update<SecretPropertyType>(_: SecretPropertyType, from _: SecretPropertyType) throws where SecretPropertyType: SecretProperty {}

  func query(_: Query) throws -> [AnySecretProperty] {
    items
  }
}
