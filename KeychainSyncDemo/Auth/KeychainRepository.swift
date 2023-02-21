import Security
import FloxBxAuth

struct KeychainRepository : CredentialsRepository {
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
  
  func defaultAddQuery () -> [String : Any?] {
    return [
      kSecAttrServer as String: self.defaultServerName,
      kSecAttrAccessGroup as String: defaultAccessGroup,
      kSecAttrSynchronizable as String: self.defaultSynchronizable
    ]
  }
  func create(_ item: InternetPasswordItem) throws {
    let itemDictionary = item.addQuery()
    
    
    let query =     itemDictionary.merging(defaultAddQuery()) {
      return $0 ?? $1
    }.compactMapValues{ $0} as CFDictionary
    
    let status = SecItemAdd(query, nil)
    
    guard status == errSecSuccess else {
      throw KeychainError.unhandledError(status: status)
    }
  }
  
  func update(_ item: InternetPasswordItem) throws {
    
  }
  
  func query(_ query: Query) throws -> [InternetPasswordItem] {
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
