//
//  StealthyProperty+Dictionary.swift
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

#if canImport(Security)
  public import Security
  extension StealthyProperty {
    /// Returns an `AnyStealthyProperty` instance that wraps this `StealthyProperty`.
    public func eraseToAnyProperty() -> AnyStealthyProperty {
      .init(property: self)
    }

    /// Returns a dictionary containing the class of this `StealthyProperty`.
    public func classDictionary() -> StealthyDictionary {
      [kSecClass as String: Self.propertyType.secClass]
    }

    /// Returns a dictionary containing the data of this `StealthyProperty`.
    public func dataDictionary() -> StealthyDictionary {
      [kSecValueData as String: data]
    }

    /// Returns a dictionary containing all attributes of this `StealthyProperty`.
    public func attributesDictionary() -> StealthyDictionary {
      otherProperties().merging(with: dataDictionary(), overwrite: true)
    }

    /// Returns a dictionary containing the unique attributes of this `StealthyProperty`.
    public func fetchQuery() -> StealthyDictionary {
      uniqueAttributes().merging(with: classDictionary(), overwrite: false)
    }

    /// Returns a dictionary containing the attributes to add this `StealthyProperty`.
    public func addQuery() -> StealthyDictionary {
      fetchQuery().merging(with: attributesDictionary(), overwrite: false)
    }

    /// Returns a dictionary containing the attributes to update this `StealthyProperty`.
    public func updateQuery() -> StealthyDictionary {
      uniqueAttributes().merging(with: attributesDictionary(), overwrite: false)
    }

    /// Returns a dictionary containing the attributes to delete this `StealthyProperty`.
    public func deleteQuery() -> StealthyDictionary {
      fetchQuery()
    }

    /// Returns an `UpdateQuerySet` instance containing the query and attributes
    /// to update this `StealthyProperty`.
    public func updateQuerySet() -> UpdateQuerySet {
      .init(query: fetchQuery(), attributes: attributesDictionary())
    }
  }

#endif
