extension StealthyRepository {
  /// Saves the keychain items based on the model.
  /// - Parameter model: The model which contains the properties to create.
  public func create<StealthyModelType: StealthyModel>(
    _ model: StealthyModelType
  ) throws {
    let properties = StealthyModelType.QueryBuilder.properties(from: model, for: .adding)
    for property in properties {
      try create(property)
    }
  }

  /// Updates the keychain based on changes to the model.
  /// - Parameters:
  ///   - previousItem: The previous model.
  ///   - newItem: The updated model.
  public func update<StealthyModelType: StealthyModel>(
    from previousItem: StealthyModelType,
    to newItem: StealthyModelType
  ) throws {
    let updates = StealthyModelType.QueryBuilder.updates(from: previousItem, to: newItem)
    for update in updates {
      if let newProperty = update.newProperty?.property {
        try upsert(from: update.previousProperty, to: newProperty)
      } else if let previousProperty = update.previousProperty {
        try delete(previousProperty)
      }
    }
  }

  /// Deletes the model's properties from the repository.
  /// - Parameter model: The model to delete.
  public func delete<StealthyModelType: StealthyModel>(
    _ model: StealthyModelType
  ) throws {
    let properties = StealthyModelType.QueryBuilder.properties(
      from: model,
      for: .deleting
    )
    for property in properties {
      try delete(property)
    }
  }

  /// Fetches the model based on the query given.
  /// - Parameter query: The query.
  /// - Returns: The Model if it exists.
  public func fetch<StealthyModelType: StealthyModel>(
    _ query: StealthyModelType.QueryBuilder.QueryType
  ) async throws -> StealthyModelType? {
    let properties = try await withThrowingTaskGroup(
      of: (String, [AnyStealthyProperty]).self,
      returning: [String: [AnyStealthyProperty]].self
    ) { taskGroup in
      let queries = StealthyModelType.QueryBuilder.queries(from: query)
      for (id, query) in queries {
        taskGroup.addTask {
          try (id, self.query(query))
        }
      }

      return try await taskGroup
        .reduce(into: [String: [AnyStealthyProperty]]()) { result, pair in
          result[pair.0] = pair.1
        }
    }
    return try StealthyModelType.QueryBuilder.model(from: properties)
  }

  /// If there should only be one instance in the keychain, this will return that item.
  /// - Returns: The Model if it exists.
  public func fetch<StealthyModelType: StealthyModel>() async throws -> StealthyModelType?
    where StealthyModelType.QueryBuilder.QueryType == Void {
    try await fetch(())
  }
}
