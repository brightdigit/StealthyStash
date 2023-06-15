#if canImport(Security)
  import Security

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
        kSecAttrAccessGroup as String: defaultAccessGroup
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
        kSecAttrSynchronizable as String: defaultSynchronizable.cfValue
      ]
    }
  }
#endif
