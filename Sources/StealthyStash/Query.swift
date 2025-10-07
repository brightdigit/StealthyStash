//
//  Query.swift
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

/// A protocol for queries to the keychain.
public protocol Query: Sendable {
  /// The type of property being queried.
  var type: StealthyPropertyType { get }

  #if canImport(Security)
    /// Returns a dictionary of keychain query parameters.
    /// - Returns: A dictionary of keychain query parameters.
    func keychainDictionary() -> StealthyDictionary
  #endif
}

#if canImport(Security)
  public import Security

  extension Query {
    /// Returns a dictionary of keychain query parameters.
    /// - Returns: A dictionary of keychain query parameters.
    public func keychainDictionary() -> StealthyDictionary {
      [
        kSecClass as String: type.secClass,
        kSecReturnAttributes as String: true,
        kSecReturnData as String: true,
        kSecAttrSynchronizable as String: kSecAttrSynchronizableAny as String,
        kSecMatchLimit as String: kSecMatchLimitAll as String,
      ]
    }
  }
#endif
