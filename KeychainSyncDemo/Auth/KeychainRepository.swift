import Security
import FloxBxAuth

struct KeychainRepository : CredentialsRepository {

  
  func create(_ item: AnyCredentialProperty) throws {
    let itemDictionary = item.property.addQuery()
    
    
    let query =     itemDictionary.merging(defaultAddQuery(forType: item.propertyType)) {
      return $0 ?? $1
    }.compactMapValues{ $0} as CFDictionary
    
    let status = SecItemAdd(query, nil)
    
    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
  }
  
  func update(_ item: AnyCredentialProperty) throws {
    
  }
  
  func query(_ query: Query) throws -> [AnyCredentialProperty] {
    let dictionaryAny = [
      kSecClass as String: query.type.secClass,
      kSecAttrServer as String: query.type == .internet ? defaultServerName : nil,
      kSecAttrService as String: query.type == .generic ? defaultServiceName : nil,
      kSecReturnAttributes as String: true,
      kSecReturnData as String: true,
      kSecAttrAccessGroup as String: defaultAccessGroup,
      kSecAttrSynchronizable as String: kSecAttrSynchronizableAny,
      kSecMatchLimit as String: kSecMatchLimitAll
    ] as [String : Any?]
    
    var item: CFTypeRef?
    let cfQuery = dictionaryAny.compactMapValues{$0} as CFDictionary
    
    let status = SecItemCopyMatching(cfQuery, &item)
        
    guard status != errSecItemNotFound else {
      return []
    }
    guard let dictionaries = item as? [[String : Any]], status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
    
    do {
      return try dictionaries.map(query.type.propertyType.init(dictionary:)).map(AnyCredentialProperty.init(property:))
    } catch {
      assertionFailure(error.localizedDescription)
      return []
    }
  }
  
  public init(defaultServiceName: String, defaultServerName: String, defaultAccessGroup: String? = nil, defaultSynchronizable: Bool? = nil) {
    self.defaultServiceName = defaultServiceName
    self.defaultServerName = defaultServerName
    self.defaultAccessGroup = defaultAccessGroup
    self.defaultSynchronizable = defaultSynchronizable
  }
  
  let defaultServiceName : String
  let defaultServerName : String
  let defaultAccessGroup : String?
  let defaultSynchronizable : Bool?
  
  func defaultAddQuery (forType type: CredentialPropertyType) -> [String : Any?] {
    return [
      kSecAttrService as String: type == .generic ? self.defaultServiceName : nil,
      kSecAttrServer as String: type == .internet ? self.defaultServerName : nil,
      kSecAttrAccessGroup as String: defaultAccessGroup,
      kSecAttrSynchronizable as String: self.defaultSynchronizable
    ]
  }
  

  
  @available(*, deprecated)
  func create(_ item: InternetPasswordItem) throws {
    let itemDictionary = item.addQuery()
    
    
    let query =     itemDictionary.merging(defaultAddQuery(forType: .internet)) {
      return $0 ?? $1
    }.compactMapValues{ $0} as CFDictionary
    
    let status = SecItemAdd(query, nil)
    
    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
  }
  
  @available(*, deprecated)
  func update(_ item: InternetPasswordItem) throws {
    
  }
  
  @available(*, deprecated)
  func queryItems(_ query: Query) throws -> [InternetPasswordItem] {
    let dictionaryAny = [
      kSecClass as String: kSecClassInternetPassword,
      kSecAttrServer as String: defaultServerName,
      kSecReturnAttributes as String: true,
      kSecReturnData as String: true,
      kSecAttrAccessGroup as String: defaultAccessGroup,
      kSecAttrSynchronizable as String: kSecAttrSynchronizableAny,
      kSecMatchLimit as String: kSecMatchLimitAll
    ] as [String : Any?]
    
    var item: CFTypeRef?
    let query = dictionaryAny.compactMapValues{$0} as CFDictionary
    
    let status = SecItemCopyMatching(query, &item)
        
    guard status != errSecItemNotFound else {
      return []
    }
    guard let dictionaries = item as? [[String : Any]], status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
    
    do {
      return try dictionaries.map(InternetPasswordItem.init(dictionary:))
    } catch {
      assertionFailure(error.localizedDescription)
      return []
    }
    
  }
}
