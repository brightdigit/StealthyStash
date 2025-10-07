//
//  InternetPasswordItem.swift
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

/// A struct representing an internet password item.
public struct InternetPasswordItem: Identifiable, Hashable, StealthyProperty {
  /// The account name associated with the password.
  public let account: String

  /// The password data.
  public let data: Data

  /// The access group for the password item.
  public let accessGroup: String?

  /// The creation date of the password item.
  public let createdAt: Date?

  /// The modification date of the password item.
  public let modifiedAt: Date?

  /// A description of the password item.
  public let description: String?

  /// A comment associated with the password item.
  public let comment: String?

  /// The type of the password item.
  public let type: Int?

  /// The label of the password item.
  public let label: String?

  /// The server associated with the password item.
  public let server: String?

  /// The protocol used by the server.
  public let `protocol`: ServerProtocol?

  /// The authentication type used by the server.
  public let authenticationType: AuthenticationType?

  /// The port used by the server.
  public let port: Int?

  /// The path of the server.
  public let path: String?

  /// Whether the password item is synchronizable.
  public let isSynchronizable: Synchronizable

  /// Initializes a new `InternetPasswordItem`.
  public init(
    account: String,
    data: Data,
    accessGroup: String? = nil,
    createdAt: Date? = nil,
    modifiedAt: Date? = nil,
    description: String? = nil,
    comment: String? = nil,
    type: Int? = nil,
    label: String? = nil,
    server: String? = nil,
    protocol: ServerProtocol? = nil,
    authenticationType: AuthenticationType? = nil,
    port: Int? = nil,
    path: String? = nil,
    isSynchronizable: Synchronizable = .any
  ) {
    self.account = account
    self.data = data
    self.accessGroup = accessGroup
    self.createdAt = createdAt
    self.modifiedAt = modifiedAt
    self.description = description
    self.comment = comment
    self.type = type
    self.label = label
    self.server = server
    self.protocol = `protocol`
    self.authenticationType = authenticationType
    self.port = port
    self.path = path
    self.isSynchronizable = isSynchronizable
  }
}
