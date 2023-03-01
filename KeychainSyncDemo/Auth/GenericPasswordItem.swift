import Security
import Foundation

public struct GenericPasswordItem : Identifiable, Hashable{
  public var id: String {
    
    [self.account,
    self.server,
     self.protocol?.rawValue,
    self.authenticationType,
     self.port?.description,
     self.path].compactMap{$0}.joined()
  }
  
  
  func addQuery () -> [String : Any?]
  {
    [
     kSecClass as String: kSecClassInternetPassword,
     kSecAttrAccount as String: self.account,
     kSecValueData as String: self.data,
     kSecAttrServer as String: self.server?.nilTrimmed(),
     kSecAttrAccessGroup as String: self.accessGroup?.nilTrimmed(),
     kSecAttrSynchronizable as String: self.isSynchronizable,
     kSecAttrDescription as String : description?.nilTrimmed(),
     kSecAttrType as String : type,
     kSecAttrLabel as String : label,
     kSecAttrProtocol as String : self.protocol?.cfValue,
     kSecAttrAuthenticationType as String : authenticationType,
     kSecAttrPort as String : port,
     kSecAttrPath as String : path
   ]
  }
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

extension GenericPasswordItem {
  public var dataString : String {
    String(data: self.data, encoding: .utf8) ?? ""
  }
}
//
//extension GenericPasswordItem {
//  init(data: InternetPasswordData) {
//    self.init(
//      account: data.account,
//      data: data.data.data(using: .utf8)!,
//      accessGroup: data.accessGroup,
//      createdAt: data.createdAt,
//      modifiedAt: data.modifiedAt,
//      description: data.description,
//      type: data.type,
//      label: data.label,
//      server: data.url?.host,
//      protocol: data.url?.scheme.flatMap(ServerProtocol.init(scheme:)),
//      port: data.url?.port,
//      path: data.url?.path,
//      isSynchronizable: data.isSynchronizable
//    )
//  }
//}

extension GenericPasswordItem {
  init(dictionary : [String : Any]) throws {
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
    //let authenticationType : AuthenticationType? = try dictionary.requireOptional(kSecAttrAuthenticationType)
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
//
//extension GenericPasswordItem {
//  init(builder: InternetPasswordItemBuilder) {
//    self.init(
//      account: builder.account,
//      data: builder.data,
//      accessGroup: builder.accessGroup,
//      createdAt: builder.createdAt,
//      modifiedAt: builder.modifiedAt,
//      description: builder.description,
//      type: builder.type,
//      label: builder.label,
//      server: builder.server,
//      protocol: builder.protocol,
//      port: builder.port,
//      path: builder.path,
//      isSynchronizable: builder.isSynchronizable
//    )
//  }
//}
