//
//  ModelQueryBuilder.swift
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
