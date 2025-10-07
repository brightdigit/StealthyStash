//
//  GenericPasswordItem+StealthyProperty.swift
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

public import Foundation

#if canImport(Security)

  public import Security
#endif

extension GenericPasswordItem {
  /// The type of the property.
  public static var propertyType: StealthyPropertyType {
    .generic
  }

  /// The unique identifier for the property.
  public var id: String {
    [
      account,
      service,
    ].compactMap { $0 }.joined()
  }

  #if canImport(Security)
    internal init(
      common: CommonAttributes,
      service: String? = nil,
      generic: Data? = nil
    ) {
      self.init(
        account: common.account,
        data: common.data,
        service: service,
        accessGroup: common.accessGroup,
        createdAt: common.createdAt,
        modifiedAt: common.modifiedAt,
        description: common.description,
        comment: common.comment,
        type: common.type,
        label: common.label,
        generic: generic,
        isSynchronizable: common.isSynchronizable
      )
    }

    /// Initializes a new instance of the property from a dictionary
    /// which contains all the required values.
    public init(dictionary: StealthyDictionary) throws {
      let common: CommonAttributes = try .init(dictionary: dictionary, isRaw: false)
      let service: String = try dictionary.require(kSecAttrService)
      let generic: Data? = try dictionary.requireOptional(kSecAttrGeneric)
      self.init(
        common: common,
        service: service,
        generic: generic
      )
    }

    /// Initializes a new instance of the property from a dictionary
    /// which may not contain all the required values.
    public init(rawDictionary: StealthyDictionary) throws {
      let common: CommonAttributes = try .init(dictionary: rawDictionary, isRaw: true)
      let service: String? = try rawDictionary.requireOptional(kSecAttrService)
      let generic: Data? = try rawDictionary.requireOptional(kSecAttrGeneric)
      self.init(
        common: common,
        service: service,
        generic: generic
      )
    }

    /// Returns a dictionary of unique attributes for fetching property.
    public func uniqueAttributes() -> StealthyDictionary {
      [
        kSecAttrAccount as String: account,
        kSecAttrService as String: service,
        kSecAttrAccessGroup as String: accessGroup,
        kSecAttrSynchronizable as String: isSynchronizable.cfValue,
      ]
    }

    /// Returns a dictionary of other properties for updating or creating the property.
    public func otherProperties() -> StealthyDictionary {
      [
        kSecAttrGeneric as String: generic,
        kSecAttrDescription as String: description,
        kSecAttrComment as String: comment,
        kSecAttrType as String: type,
        kSecAttrLabel as String: label,
      ]
    }
  #endif
}
