extension SecretsRepository {
  public func create<SecretModelType: SecretModel>(_ model: SecretModelType) throws {
    let properties = SecretModelType.QueryBuilder.properties(from: model, for: .adding)
    for property in properties {
      try create(property)
    }
  }

  public func update<SecretModelType: SecretModel>(from previousItem: SecretModelType, to newItem: SecretModelType) throws {
    let updates = SecretModelType.QueryBuilder.updates(from: previousItem, to: newItem)
    for update in updates {
      if let newProperty = update.newProperty?.property {
        try upsert(from: update.previousProperty, to: newProperty)
      } else if let previousProperty = update.previousProperty {
        try delete(previousProperty)
      }
    }
  }

  public func delete<SecretModelType: SecretModel>(_ model: SecretModelType) throws {
    let properties = SecretModelType.QueryBuilder.properties(from: model, for: .deleting)
    for property in properties {
      try delete(property)
    }
  }

  public func fetch<SecretModelType: SecretModel>(_ query: SecretModelType.QueryBuilder.QueryType) async throws -> SecretModelType? {
    let properties = try await withThrowingTaskGroup(of: (String, [AnySecretProperty]).self, returning: [String: [AnySecretProperty]].self) { taskGroup in
      let queries = SecretModelType.QueryBuilder.queries(from: query)
      for (id, query) in queries {
        taskGroup.addTask {
          try (id, self.query(query))
        }
      }

      return try await taskGroup.reduce(into: [String: [AnySecretProperty]]()) { result, pair in
        result[pair.0] = pair.1
      }
    }
    return try SecretModelType.QueryBuilder.model(from: properties)
  }

  public func fetch<SecretModelType: SecretModel>() async throws -> SecretModelType? where SecretModelType.QueryBuilder.QueryType == Void {
    try await fetch(())
  }
}
