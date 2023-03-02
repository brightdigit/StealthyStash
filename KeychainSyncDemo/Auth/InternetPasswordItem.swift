import Security
import Foundation

public struct InternetPasswordItem : Identifiable, Hashable, SecretProperty{
  
  public func uniqueAttributes() -> SecretDictionary {
    
      /*
       For internet passwords, the primary keys include kSecAttrAccount, kSecAttrSecurityDomain, kSecAttrServer, kSecAttrProtocol, kSecAttrAuthenticationType, kSecAttrPort, and kSecAttrPath
       */
    return [
      kSecAttrAccount as String: self.account,
      kSecAttrAccessGroup as String: self.accessGroup?.nilTrimmed(),
      
      //kSecAttrSecurityDomain as String, self.account
      kSecAttrServer as String: self.server,
      kSecAttrProtocol as String: self.protocol,
      //kSecAttrAuthenticationType as String, self.account
      kSecAttrPort as String: self.port,
      kSecAttrPath as String: self.path
    ]
  }
  
  public func otherProperties() -> SecretDictionary {
    [
      kSecAttrSynchronizable as String: self.isSynchronizable,
      kSecAttrDescription as String : description?.nilTrimmed(),
      kSecAttrType as String : type,
      kSecAttrLabel as String : label,
    ]
  }
//  
//  public func deleteQuery() -> [String : Any?] {
//    let addQuery = addQuery()
//    let uniqueKeys = [kSecAttrService as String, kSecAttrAccount as String]
//    var query = [String : Any?]()
//    var attributes = [String : Any?]()
//    for (key, value) in addQuery {
//      if uniqueKeys.contains(key) {
//        query[key] = value
//      } else {
//        attributes[key] = value
//      }
//    }
//    query[kSecClass as String] = Self.propertyType.secClass
//    return query
//  }
//  
//  public func updateQuerySet() -> UpdateQuerySet {
//    let addQuery = addQuery()
//    let uniqueKeys = [kSecAttrServer as String, kSecAttrAccount as String]
//    var query = [String : Any?]()
//    var attributes = [String : Any?]()
//    for (key, value) in addQuery {
//      if uniqueKeys.contains(key) {
//        query[key] = value
//      } else {
//        attributes[key] = value
//      }
//    }
//    query[kSecClass as String] = Self.propertyType.secClass
//    return .init(query: query, attributes: attributes, id: self.id)
//  }
  
  public static let propertyType: SecretPropertyType = .internet
  
  public var id: String {
    
    [self.account,
    self.server,
     self.protocol?.rawValue,
    self.authenticationType,
     self.port?.description,
     self.path].compactMap{$0}.joined()
  }
  
//
//  public func addQuery () -> [String : Any?]
//  {
//    [
//     kSecClass as String: kSecClassInternetPassword,
//     kSecAttrAccount as String: self.account,
//     kSecValueData as String: self.data,
//     kSecAttrServer as String: self.server?.nilTrimmed(),
//     kSecAttrAccessGroup as String: self.accessGroup?.nilTrimmed(),
//     kSecAttrSynchronizable as String: self.isSynchronizable,
//     kSecAttrDescription as String : description?.nilTrimmed(),
//     kSecAttrType as String : type,
//     kSecAttrLabel as String : label,
//     kSecAttrProtocol as String : self.protocol?.cfValue,
//     kSecAttrAuthenticationType as String : authenticationType,
//     kSecAttrPort as String : port,
//     kSecAttrPath as String : path
//   ]
//  }
  public init(account: String, data: Data, accessGroup: String? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, description: String? = nil, comment : String? = nil, type: Int? = nil, label: String? = nil, server: String? = nil, `protocol`: ServerProtocol? = nil, authenticationType: AuthenticationType? = nil, port: Int? = nil, path: String? = nil, isSynchronizable: Bool? = nil) {
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
    self.`protocol` = `protocol`
    self.authenticationType = authenticationType
    self.port = port
    self.path = path
    self.isSynchronizable = isSynchronizable
  }
  
  public let account : String
  public let data : Data
   
  public let accessGroup : String?
  public let createdAt : Date?
  public let modifiedAt : Date?
  public let description: String?
  public let comment : String?
  public let type : Int?
  public let label : String?
  public let server : String?
  public let `protocol` : ServerProtocol?
  public let authenticationType : AuthenticationType?
  public let port: Int?
  public let path: String?
  public let isSynchronizable : Bool?
}


extension InternetPasswordItem {
  public init(dictionary : [String : Any]) throws {
    let account : String = try dictionary.require(kSecAttrAccount)
    let data : Data = try dictionary.require(kSecValueData)
    let accessGroup : String? = try dictionary.requireOptional(kSecAttrAccessGroup)
    let createdAt : Date? = try dictionary.requireOptional(kSecAttrCreationDate)
    let modifiedAt : Date? = try dictionary.requireOptional(kSecAttrModificationDate)
    let description: String? = try dictionary.requireOptional(kSecAttrDescription)
    let type : Int? = try dictionary.requireOptionalCF(kSecAttrType)
    let label : String? = try dictionary.requireOptionalCF(kSecAttrLabel)
    let server : String? = try dictionary.requireOptional(kSecAttrServer)
    let protocolString : CFString? = try dictionary.requireOptional(kSecAttrProtocol)
    let `protocol` : ServerProtocol? = protocolString.flatMap(ServerProtocol.init(number: ))
    let port: Int? = try dictionary.requireOptional(kSecAttrPort)
    let path: String? = try dictionary.requireOptional(kSecAttrPath)
    let isSynchronizable : Bool? = try dictionary.requireOptional(kSecAttrSynchronizable)
    self.init(
      account: account,
      data: data,
      accessGroup: accessGroup,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      description: description,
      type: type?.trimZero(),
      label: label,
      server: server,
      protocol: `protocol`,
      port: port?.trimZero(),
      path: path,
      isSynchronizable: isSynchronizable
    )
  }
}

extension InternetPasswordItem {
  public init(builder: SecretPropertyBuilder) {
    self.init(
      account: builder.account,
      data: builder.data,
      accessGroup: builder.accessGroup,
      createdAt: builder.createdAt,
      modifiedAt: builder.modifiedAt,
      description: builder.description,
      type: builder.type,
      label: builder.label,
      server: builder.server,
      protocol: builder.protocol,
      port: builder.port,
      path: builder.path,
      isSynchronizable: builder.isSynchronizable
    )
  }
}
