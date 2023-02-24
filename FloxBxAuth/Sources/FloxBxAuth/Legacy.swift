//
//  File.swift
//  
//
//  Created by Leo Dion on 2/23/23.
//

import Foundation
import Combine

public struct LegacyPreviewRepository : LegacyCredentialRepository {
  public init () {}
  public func addItem(_ item: LegacyCredentialItem) {
    
  }
  
  
}


@available(*, deprecated)
public protocol LegacyCredentialRepository {
  func addItem(_ item: LegacyCredentialItem) throws
}

public struct LegacyCreditialItemBuilder {
  public  init(itemClass: LegacyItemClass = .generic, dataString: String = "", account: String = "", type: Int = 0, containsType: Bool = false, label: String = "", containsLabel: Bool = false) {
    self.itemClass = itemClass
    self.dataString = dataString
    self.account = account
    self.type = type
    self.containsType = containsType
    self.label = label
    self.containsLabel = containsLabel
  }
  
  public var itemClass : LegacyItemClass = .generic
  public var dataString : String = ""
  public var account: String = ""
  public var type : Int = 0
  public var containsType : Bool = false
  public var label : String = ""
  public var containsLabel : Bool = false
}
public struct LegacyCredentialItem {
  public  init(itemClass: LegacyItemClass, data: Data, account: String, type: Int? = nil, label: String? = nil, isSynchronizable : Bool? = nil) {
    self.itemClass = itemClass
    self.data = data
    self.account = account
    self.type = type
    self.label = label
    self.serviceName = nil
    self.server = nil
    self.accessGroup = nil
    self.isSynchronizable = isSynchronizable
  }
  
  let itemClass : LegacyItemClass
  let data : Data
  let account: String
  let type : Int?
  let label : String?
  let serviceName : String?
  let server : String?
  let accessGroup : String?
  let isSynchronizable : Bool?
}

public extension LegacyCredentialItem {
  init (builder : LegacyCreditialItemBuilder) {
    guard let data = builder.dataString.data(
      using: .utf8,
      allowLossyConversion: false
    ) else {
      preconditionFailure("Can't extract data from string: \(builder.dataString)")
    }
    self.init(itemClass: builder.itemClass, data: data, account: builder.account,
              type: builder.containsType ? builder.type : nil,
              label: builder.containsLabel ? builder.label : nil)
  }
}

@available(*, deprecated)
public class LegacyAddItemObject : ObservableObject {
  public  init(repository: LegacyCredentialRepository, item: LegacyCreditialItemBuilder = LegacyCreditialItemBuilder(), lastError: KeychainError? = nil) {
    self.repository = repository
    self.item = item
    self.lastError = lastError
    
    let itemAddResult = self.triggerAddSubject
      .map { self.item  }
      .map(LegacyCredentialItem.init(builder:))
      .map { item in
        Result {
          try self.repository.addItem(item)
        }
      }.share()
    
    
    itemAddResult.compactMap{try? $0.get()}.map {
      LegacyCreditialItemBuilder()
    }.assign(to: &self.$item)
    
    itemAddResult.compactMap{ result -> KeychainError? in
      guard case .failure(let error as KeychainError) = result else {
        return nil
      }
      
      return error
    }.map{$0 as KeychainError?}
      .assign(to: &self.$lastError)
  }
  
  
  let repository : LegacyCredentialRepository
  
  @Published public var item = LegacyCreditialItemBuilder()
  let triggerAddSubject = PassthroughSubject<Void, Never>()
  @Published public var lastError : KeychainError?
  
  
  public func addItem () {
    triggerAddSubject.send()
  }
}

@available(*, deprecated)
public enum LegacyItemClass : Int, CaseIterable, CustomStringConvertible, Identifiable, Hashable {

  
 
  public var id: Int {
    return self.rawValue
  }
  
  case generic
  case internet
  
  public var description: String {
    switch self {
    case .generic:
      return "Generic"
    case .internet:
      return "Internet"
    }
  }
  
  var classValue : CFString {
    switch self {
    case .generic:
      return kSecClassGenericPassword
    case .internet:
      return kSecClassInternetPassword
    }
  }
}
