import Security
import Foundation

public struct GenericPasswordItem : Identifiable, Hashable, CredentialProperty{
  public init(builder: InternetPasswordItemBuilder) throws {
    fatalError()
  }
  
  public static var propertyType: CredentialPropertyType {
    return .generic
  }
  
  internal init(account: String, data: Data, service: String? = nil, accessGroup: String? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, description: String? = nil, comment: String? = nil, type: Int? = nil, label: String? = nil, gerneic: Data? = nil, isSynchronizable: Bool? = nil) {
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
    self.gerneic = gerneic
    self.isSynchronizable = isSynchronizable
  }
  
  public var id: String {
    
    [self.account,
    self.service].compactMap{$0}.joined()
  }
  
  
  public func addQuery () -> [String : Any?]
  {
    [
     kSecClass as String: kSecClassInternetPassword,
     kSecAttrAccount as String: self.account,
     kSecValueData as String: self.data,
     kSecAttrService as String: self.service?.nilTrimmed(),
     kSecAttrGeneric as String: self.gerneic,
     kSecAttrAccessGroup as String: self.accessGroup?.nilTrimmed(),
     kSecAttrSynchronizable as String: self.isSynchronizable,
     kSecAttrDescription as String : description?.nilTrimmed(),
     kSecAttrComment as String : comment?.nilTrimmed(),
     kSecAttrType as String : type,
     kSecAttrLabel as String : label
   ]
  }
  
  public let account : String
  public let data : Data
  public let service : String?
  public let accessGroup : String?
  public let createdAt : Date?
  public let modifiedAt : Date?
  public let description: String?
  public let comment : String?
  public let type : Int?
  public let label : String?
  public let gerneic : Data?
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
  public init(dictionary : [String : Any]) throws {
    let account : String = try dictionary.require(kSecAttrAccount)
    let data : Data = try dictionary.require(kSecValueData)
    let accessGroup : String? = try dictionary.requireOptional(kSecAttrAccessGroup)
    let createdAt : Date? = try dictionary.requireOptional(kSecAttrCreationDate)
    let modifiedAt : Date? = try dictionary.requireOptional(kSecAttrModificationDate)
    let description: String? = try dictionary.requireOptional(kSecAttrDescription)
    let type : Int? = try dictionary.requireOptionalCF(kSecAttrType)
    let label : String? = try dictionary.requireOptionalCF(kSecAttrLabel)
    let service : String = try dictionary.require(kSecAttrService)
    let generic : Data? = try dictionary.requireOptional(kSecAttrGeneric)
    let isSynchronizable : Bool? = try dictionary.requireOptional(kSecAttrSynchronizable)
    self.init(
      account: account,
      data: data,
      service: service,
      accessGroup: accessGroup,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      description: description,
      type: type?.trimZero(),
      label: label,
      gerneic: generic,
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
