#if canImport(Security)

  import os

  public struct KeychainRepository: StealthyRepository {
    internal let defaultProvider: DefaultProvider?
    public let logger: Logger?

    public init(defaultProvider: DefaultProvider? = nil, logger: Logger? = nil) {
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
