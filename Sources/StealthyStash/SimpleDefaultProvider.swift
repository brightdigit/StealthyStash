//
//  SimpleDefaultProvider.swift
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

  /// A default provider for `Stealthy`.
  internal struct SimpleDefaultProvider: DefaultProvider {
    /// The default service name.
    private let defaultServiceName: String

    /// The default server name.
    private let defaultServerName: String

    /// The default access group.
    private let defaultAccessGroup: String?

    /// The default synchronizable option.
    private let defaultSynchronizable: Synchronizable

    /// Initializes a new `SimpleDefaultProvider`.
    ///
    /// - Parameters:
    ///   - defaultServiceName: The default service name.
    ///   - defaultServerName: The default server name.
    ///   - defaultAccessGroup: The default access group.
    ///   - defaultSynchronizable: The default synchronizable option.
    internal init(
      defaultServiceName: String,
      defaultServerName: String,
      defaultAccessGroup: String? = nil,
      defaultSynchronizable: Synchronizable = .any
    ) {
      self.defaultServiceName = defaultServiceName
      self.defaultServerName = defaultServerName
      self.defaultAccessGroup = defaultAccessGroup
      self.defaultSynchronizable = defaultSynchronizable
    }

    /// Returns the attributes for a query of the given type.
    ///
    /// - Parameter type: The type of query to perform.
    /// - Returns: A dictionary of attributes for the query.
    internal func attributesForQuery(
      ofType type: StealthyPropertyType?
    ) -> StealthyDictionary {
      [
        kSecAttrServer as String: type == .internet ? defaultServerName : nil,
        kSecAttrService as String: type == .generic ? defaultServiceName : nil,
        kSecAttrAccessGroup as String: defaultAccessGroup,
      ]
    }

    /// Returns the attributes for a new item of the given type.
    ///
    /// - Parameter type: The type of item to create.
    /// - Returns: A dictionary of attributes for the new item.
    internal func attributesForNewItem(
      ofType type: StealthyPropertyType
    ) -> StealthyDictionary {
      [
        kSecAttrService as String: type == .generic ? defaultServiceName : nil,
        kSecAttrServer as String: type == .internet ? defaultServerName : nil,
        kSecAttrAccessGroup as String: defaultAccessGroup,
        kSecAttrSynchronizable as String: defaultSynchronizable.cfValue,
      ]
    }
  }
#endif
