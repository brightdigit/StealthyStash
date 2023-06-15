#if canImport(Security)

  import os

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
