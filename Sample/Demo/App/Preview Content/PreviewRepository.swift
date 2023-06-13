import StealthyStash

struct PreviewRepository: StealthyRepository {
  func delete(_: AnyStealthyProperty) throws {}

  let items: [AnyStealthyProperty]
  func create(_: AnyStealthyProperty) throws {}

  func update(_: AnyStealthyProperty) throws {}

  func update<StealthyPropertyType>(_: StealthyPropertyType, from _: StealthyPropertyType) throws where StealthyPropertyType: StealthyProperty {}

  func query(_: Query) throws -> [AnyStealthyProperty] {
    items
  }
}
