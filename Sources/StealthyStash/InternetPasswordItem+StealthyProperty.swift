//
//  InternetPasswordItem+StealthyProperty.swift
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

extension InternetPasswordItem {
  /// The type of the property.
  public static let propertyType: StealthyPropertyType = .internet

  /// The unique identifier for the property.
  public var id: String {
    [
      account,
      server,
      self.protocol?.rawValue,
      authenticationType,
      port?.description,
      path,
    ].compactMap { $0 }.joined()
  }

  #if canImport(Security)
    /// Initializes a new instance of the property from a dictionary
    /// which contains all the required values.
    public init(dictionary: StealthyDictionary) throws {
      let common: CommonAttributes = try .init(dictionary: dictionary, isRaw: false)
      let server: String? = try dictionary.requireOptional(kSecAttrServer)
      let protocolString: CFString? = try dictionary.requireOptional(kSecAttrProtocol)
      let `protocol` = protocolString.flatMap(ServerProtocol.init(number:))
      let port: Int? = try dictionary.requireOptional(kSecAttrPort)
      let path: String? = try dictionary.requireOptional(kSecAttrPath)
      self.init(
        common: common,
        server: server,
        protocol: `protocol`,
        port: port?.trimZero(),
        path: path
      )
    }

    /// Initializes a new instance of the property from a dictionary
    /// which may not contain all the required values.
    public init(rawDictionary: StealthyDictionary) throws {
      let common: CommonAttributes = try .init(dictionary: rawDictionary, isRaw: true)
      let server: String? = try rawDictionary.requireOptional(kSecAttrServer)
      let protocolString: CFString? = try rawDictionary.requireOptional(kSecAttrProtocol)
      let `protocol` = protocolString.flatMap(ServerProtocol.init(number:))
      let port: Int? = try rawDictionary.requireOptional(kSecAttrPort)
      let path: String? = try rawDictionary.requireOptional(kSecAttrPath)
      self.init(
        common: common,
        server: server,
        protocol: `protocol`,
        port: port?.trimZero(),
        path: path
      )
    }

    internal init(
      common: CommonAttributes,
      server: String? = nil,
      protocol: ServerProtocol? = nil,
      authenticationType _: AuthenticationType? = nil,
      port: Int? = nil,
      path: String? = nil
    ) {
      self.init(
        account: common.account,
        data: common.data,
        accessGroup: common.accessGroup,
        createdAt: common.createdAt,
        modifiedAt: common.modifiedAt,
        description: common.description,
        comment: common.comment,
        type: common.type,
        label: common.label,
        server: server,
        protocol: `protocol`,
        port: port?.trimZero(),
        path: path,
        isSynchronizable: common.isSynchronizable
      )
    }

    /// Returns a dictionary of unique attributes for fetching property.
    public func uniqueAttributes() -> StealthyDictionary {
      [
        kSecAttrAccount as String: account,
        kSecAttrAccessGroup as String: accessGroup,
        kSecAttrServer as String: server,
        kSecAttrProtocol as String: self.protocol?.cfValue,
        kSecAttrPort as String: port,
        kSecAttrPath as String: path,
        kSecAttrSynchronizable as String: isSynchronizable.cfValue,
      ]
    }

    /// Returns a dictionary of other properties for updating or creating the property.
    public func otherProperties() -> StealthyDictionary {
      [
        kSecAttrSynchronizable as String: isSynchronizable.cfValue,
        kSecAttrDescription as String: description,
        kSecAttrType as String: type,
        kSecAttrLabel as String: label,
      ]
    }
  #endif
}
