import Foundation
import StealthyStash

public struct StealthyPropertyBuilder {
  public let secClass: StealthyPropertyType
  public init(
    secClass: StealthyPropertyType,
    source: AnyStealthyProperty? = nil,
    account: String = "",
    data: Data = .init(),
    accessGroup: String? = nil,
    createdAt: Date? = nil,
    modifiedAt: Date? = nil,
    description: String? = nil,
    type: Int? = nil,
    label: String? = nil,
    service: String? = nil,
    server: String? = nil,
    protocol: ServerProtocol? = nil,
    authenticationType: AuthenticationType? = nil,
    port: Int? = nil,
    path: String? = nil,
    isSynchronizable: Synchronizable = .any
  ) {
    self.secClass = secClass
    self.source = source
    self.account = account
    self.data = data
    self.accessGroup = accessGroup
    self.createdAt = createdAt
    self.modifiedAt = modifiedAt
    self.description = description
    typeValue = type ?? 0
    hasType = type != nil
    labelValue = label ?? ""
    hasLabel = label != nil
    self.service = service
    self.server = server
    self.protocol = `protocol`
    self.authenticationType = authenticationType
    self.port = port
    self.path = path
    isSynchronizableValue = isSynchronizable == .enabled
    isSynchronizableSet = isSynchronizable != .any
  }

  public var source: AnyStealthyProperty?
  public var account: String
  public var data: Data
  public var accessGroup: String?
  public var createdAt: Date?
  public var modifiedAt: Date?
  public var description: String?
  public var typeValue: Int
  public var hasType: Bool
  public var labelValue: String
  public var hasLabel: Bool
  public var service: String?
  public var server: String?
  public var `protocol`: ServerProtocol?
  public var authenticationType: AuthenticationType?
  public var port: Int?
  public var path: String?
  public var isSynchronizableValue: Bool
  public var isSynchronizableSet: Bool
}

extension StealthyPropertyBuilder {
  public var dataString: String {
    get {
      String(data: data, encoding: .utf8) ?? ""
    }
    set {
      data = newValue.data(using: .utf8) ?? .init()
    }
  }

  public var url: URL? {
    var components = URLComponents()
    components.scheme = self.protocol?.rawValue
    components.host = server
    components.path = path ?? ""
    components.port = port
    return components.url
  }

  public var descriptionText: String {
    get {
      description ?? ""
    }
    set {
      description = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }
  }

  public var accessGroupText: String {
    get {
      accessGroup ?? ""
    }
    set {
      accessGroup = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }
  }

  public var label: String? {
    hasLabel ? labelValue : nil
  }

  public var type: Int? {
    hasType ? typeValue : nil
  }

  public var isSynchronizable: Synchronizable {
    isSynchronizableSet ? .init(isSynchronizableValue) : .any
  }

  public var isModified: Bool {
    guard let source else {
      return true
    }
    return [
      account != source.account,
      isSynchronizable != source.isSynchronizable,
      type != source.type,
      accessGroup != source.accessGroup,
      authenticationType != source.accessGroup,
      server != source.server,
      self.protocol != source.protocol,
      port != source.port,
      path != source.path
    ].first { !$0 } ?? true
  }

  public func saved() throws -> StealthyPropertyBuilder {
    try .init(
      secClass: secClass,
      source: .init(builder: self),
      account: account,
      data: data,
      accessGroup: accessGroup,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      description: description,
      type: type,
      label: label,
      service: service,
      server: server,
      protocol: self.protocol,
      authenticationType: authenticationType,
      port: port,
      path: path,
      isSynchronizable: isSynchronizable
    )
  }
}


extension StealthyPropertyBuilder {
  public init(item: AnyStealthyProperty) {
    assert(item.propertyType == .internet || item.service != nil)
    self.init(
      secClass: item.propertyType,
      source: item,
      account: item.account,
      data: item.data,
      accessGroup: item.accessGroup,
      createdAt: item.createdAt,
      modifiedAt: item.modifiedAt,
      description: item.description,
      type: item.type,
      label: item.label,
      service: item.service,
      server: item.server,
      protocol: item.protocol,
      port: item.port,
      path: item.path,
      isSynchronizable: item.isSynchronizable
    )
  }
}

extension StealthyProperty  {
  init(builder: StealthyPropertyBuilder) throws {
    
    try self.init(rawDictionary: .init(builder: builder))
  }
}

extension Dictionary where Key == String, Value == Any {
  init(builder: StealthyPropertyBuilder) {
    let values : [CFString : Any?] = [
      kSecAttrAccount: builder.account,
      kSecValueData: builder.data,
      kSecAttrAccessGroup: builder.accessGroup,
      kSecAttrCreationDate: builder.createdAt,
      kSecAttrModificationDate: builder.modifiedAt,
      kSecAttrDescription: builder.description,
      kSecAttrType: builder.type,
      kSecAttrLabel: builder.label,
      kSecAttrServer: builder.server,
      kSecAttrProtocol: builder.protocol?.cfValue,
      kSecAttrPort: builder.port,
      kSecAttrPath: builder.path,
      kSecAttrSynchronizable: builder.isSynchronizable.cfValue,
      kSecAttrService: builder.service
    ]
    
    self = Dictionary(uniqueKeysWithValues: values.compactMap{ pair in
      return pair.value.map{(pair.key as String, $0)}
    })
  }
}

extension AnyStealthyProperty {
  
  public init(builder: StealthyPropertyBuilder) throws {
    let propertyType = builder.secClass.propertyType
    let property = try propertyType.init(builder: builder)
    self.init(property: property)
  }
}
