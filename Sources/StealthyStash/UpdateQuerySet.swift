//
//  UpdateQuerySet.swift
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

/// A `struct` representing a set of update queries.
public struct UpdateQuerySet {
  /// The query to fetch the item to update.
  internal let query: StealthyDictionary

  /// The attributes to update on the item.
  internal let attributes: StealthyDictionary

  /// Initializes a new `UpdateQuerySet`.
  /// - Parameters:
  ///    - query: The query to fetch the item to update.
  ///    - attributes: The attributes to update on the item.
  public init(query: StealthyDictionary, attributes: StealthyDictionary) {
    self.query = query
    self.attributes = attributes
  }
}

#if canImport(Security)
  extension UpdateQuerySet {
    internal init<StealthyPropertyType: StealthyProperty>(
      from previousItem: StealthyPropertyType,
      to newItem: StealthyPropertyType
    ) {
      let query = previousItem.fetchQuery()
      let attributes = newItem.updateQuery()
      self.init(query: query, attributes: attributes)
    }
  }
#endif
