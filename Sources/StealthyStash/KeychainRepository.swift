//
//  KeychainRepository.swift
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

  public import os

  /// Repository for access the keychain.
  public struct KeychainRepository: StealthyRepository {
    internal let defaultProvider: (any DefaultProvider)?
    public let logger: Logger?

    /// Creates a keychain repository.
    /// - Parameters:
    ///   - defaultProvider: Provides the default values for each query to the keychain.
    ///   - logger: Logger to use for each log message.
    public init(defaultProvider: (any DefaultProvider)? = nil, logger: Logger? = nil) {
      self.defaultProvider = defaultProvider
      self.logger = logger ?? Self.defaultLogger
    }
  }

  extension KeychainRepository {
    /// Creates a KeychainRepository with default values for ``GenericPasswordItem``
    /// and ``InternetPasswordItem`` objects.
    /// - Parameters:
    ///   - defaultServiceName: default ``GenericPasswordItem/service`` value.
    ///   - defaultServerName: default ``InternetPasswordItem/server`` value.
    ///   - defaultAccessGroup: default ``StealthyProperty/accessGroup``
    ///   - defaultSynchronizable: default ``StealthyProperty/isSynchronizable``
    public init(
      defaultServiceName: String,
      defaultServerName: String,
      defaultAccessGroup: String? = nil,
      defaultSynchronizable: Synchronizable = .any,
      logger: Logger? = nil
    ) {
      let provider = SimpleDefaultProvider(
        defaultServiceName: defaultServiceName,
        defaultServerName: defaultServerName,
        defaultAccessGroup: defaultAccessGroup,
        defaultSynchronizable: defaultSynchronizable
      )
      self.init(defaultProvider: provider, logger: logger)
    }
  }
#endif
