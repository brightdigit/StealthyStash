//
//  StealthyRepository+StealthyModel.swift
//  StealthyStash
//
//  Created by Leo Dion.
//  Copyright © 2025 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the “Software”), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

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

      return
        try await taskGroup
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
