//
//  GenericPasswordItem.swift
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

/// A struct representing a generic password item.
public struct GenericPasswordItem: Identifiable, Hashable, StealthyProperty {
  /// The account name associated with the password.
  public let account: String

  /// The password data.
  public let data: Data

  /// The service associated with the password.
  public let service: String?

  /// The access group associated with the password.
  public let accessGroup: String?

  /// The creation date of the password.
  public let createdAt: Date?

  /// The modification date of the password.
  public let modifiedAt: Date?

  /// A description of the password.
  public let description: String?

  /// A comment associated with the password.
  public let comment: String?

  /// The type of the password.
  public let type: Int?

  /// The label of the password.
  public let label: String?

  /// The generic data associated with the password.
  public let generic: Data?

  /// Whether the password is synchronizable.
  public let isSynchronizable: Synchronizable

  /// Initializes a new `GenericPasswordItem`.
  public init(
    account: String,
    data: Data,
    service: String? = nil,
    accessGroup: String? = nil,
    createdAt: Date? = nil,
    modifiedAt: Date? = nil,
    description: String? = nil,
    comment: String? = nil,
    type: Int? = nil,
    label: String? = nil,
    generic: Data? = nil,
    isSynchronizable: Synchronizable = .any
  ) {
    self.account = account
    self.data = data
    self.service = service
    self.accessGroup = accessGroup
    self.createdAt = createdAt
    self.modifiedAt = modifiedAt
    self.description = description
    self.comment = comment
    self.type = type
    self.label = label
    self.generic = generic
    self.isSynchronizable = isSynchronizable
  }
}
