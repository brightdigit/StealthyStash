/// A protocol for models that can be used with a ``ModelQueryBuilder``.
public protocol StealthyModel {
  var account : String { get }
  /// The type of ``ModelQueryBuilder`` that can be used with this model.
  associatedtype QueryBuilder: ModelQueryBuilder
    where QueryBuilder.StealthyModelType == Self
}


public extension StealthyModel {
  
  static func dictionary(
    for keys: [String],
    from dictionary: [String: [AnyStealthyProperty]]
  ) -> [String: AnyStealthyProperty]?  {
    let catalog = catalogAccounts(keys: .init(keys), dictionary: dictionary)
    return findAccountWithMostMatches(accountCatalog: catalog, dictionary: dictionary)
  }
  
  private static func catalogAccounts(keys: Set<String>, dictionary: [String: [AnyStealthyProperty]]) -> [String: [(String, Int)]] {
      var accountCatalog = [String: [(String, Int)]]()
      
      for key in keys {
          guard let properties = dictionary[key] else { continue }
          
          for (index, property) in properties.enumerated() {
              let keyIndexTuple = (key, index)
              if var accountIndexArray = accountCatalog[property.account] {
                  accountIndexArray.append(keyIndexTuple)
                  accountCatalog[property.account] = accountIndexArray
              } else {
                  accountCatalog[property.account] = [keyIndexTuple]
              }
          }
      }
      
      return accountCatalog
  }

  private static func findAccountWithMostMatches(accountCatalog: [String: [(String, Int)]], dictionary: [String: [AnyStealthyProperty]]) -> [String: AnyStealthyProperty]? {
      var maxAccount: String?
      var maxCount = 0
      
      for (account, keyIndexArray) in accountCatalog {
          if keyIndexArray.count > maxCount {
              maxCount = keyIndexArray.count
              maxAccount = account
          }
      }
      
      guard let account = maxAccount else { return nil }
      
      var resultDictionary = [String: AnyStealthyProperty]()
      
      for (key, index) in accountCatalog[account]! {
          if let properties = dictionary[key], properties.indices.contains(index) {
              resultDictionary[key] = properties[index]
          }
      }
      
      return resultDictionary
  }
}
