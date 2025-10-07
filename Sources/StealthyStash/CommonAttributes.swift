//
//  CommonAttributes.swift
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

internal struct CommonAttributes {
  internal let account: String
  internal let data: Data
  internal let accessGroup: String?
  internal let createdAt: Date?
  internal let modifiedAt: Date?
  internal let description: String?
  internal let comment: String?
  internal let type: Int?
  internal let label: String?
  internal let isSynchronizable: Synchronizable
}

#if canImport(Security)
  extension CommonAttributes {
    internal init(dictionary: StealthyDictionary, isRaw: Bool) throws {
      let account: String = try dictionary.require(kSecAttrAccount)
      let data: Data = try dictionary.require(kSecValueData)
      let accessGroup: String? = try dictionary.requireOptional(kSecAttrAccessGroup)
      let createdAt: Date? = try dictionary.requireOptional(kSecAttrCreationDate)
      let modifiedAt: Date? = try dictionary.requireOptional(kSecAttrModificationDate)
      let description: String? = try dictionary.requireOptional(kSecAttrDescription)
      let comment: String? = try dictionary.requireOptional(kSecAttrComment)
      let type: Int? = try dictionary.requireOptionalCF(kSecAttrType)
      let label: String? = try dictionary.requireOptionalCF(kSecAttrLabel)
      let isSynchronizable: Synchronizable
      if isRaw {
        let value = dictionary[kSecAttrSynchronizable as String]
        isSynchronizable = value.flatMap(Synchronizable.init(rawDictionaryValue:)) ?? .any
      } else {
        let syncValue: Int? = try dictionary.requireOptional(kSecAttrSynchronizable)
        isSynchronizable = .init(syncValue)
      }
      self.init(
        account: account,
        data: data,
        accessGroup: accessGroup,
        createdAt: createdAt,
        modifiedAt: modifiedAt,
        description: description,
        comment: comment,
        type: type?.trimZero(),
        label: label,
        isSynchronizable: isSynchronizable
      )
    }
  }
#endif
