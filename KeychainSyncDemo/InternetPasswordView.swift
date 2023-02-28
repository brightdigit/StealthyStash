//
//  InternetPasswordView.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/24/23.
//

import SwiftUI
import Combine
import FloxBxAuth

extension String {
  func nilTrimmed ()  -> String? {
    let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed.isEmpty ? nil : trimmed
  }
}
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

struct PreviewRepository : CredentialsRepository {
  func create(_ item: InternetPasswordItem) throws {
  
  }
  
  func update(_ item: InternetPasswordItem) throws {
    
  }
  
  func query(_ query: Query) throws -> [InternetPasswordItem] {
    fatalError()
  }
  
}
public struct InternetPasswordItemBuilder {
  
  public init(source: InternetPasswordItem? = nil, account: String = "", data: Data = .init(), accessGroup: String? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, description: String? = nil, type: Int? = nil, label: String? = nil, server: String? = nil, `protocol`: ServerProtocol? = nil, authenticationType: AuthenticationType? = nil, port: Int? = nil, path: String? = nil, isSynchronizable: Bool? = nil) {
    self.source = source
    self.account = account
    self.data = data
    self.accessGroup = accessGroup
    self.createdAt = createdAt
    self.modifiedAt = modifiedAt
    self.description = description
    self.typeValue = type ?? 0
    self.hasType = type != nil
    self.labelValue = label ?? ""
    self.hasLabel = label != nil
    self.server = server
    self.`protocol` = `protocol`
    self.authenticationType = authenticationType
    self.port = port
    self.path = path
    self.isSynchronizableValue = isSynchronizable ?? false
    self.isSynchronizableSet = isSynchronizable != nil
  }
  
  public var source : InternetPasswordItem?
  public var account : String
  public var data : Data
  public var accessGroup : String?
  public var createdAt : Date?
  public var modifiedAt : Date?
  public var description: String?
  public var typeValue : Int
  public var hasType : Bool
  public var labelValue : String
  public var hasLabel : Bool
  public var server : String?
  public var `protocol` : ServerProtocol?
  public var authenticationType : AuthenticationType?
  public var port: Int?
  public var path: String?
  public var isSynchronizableValue : Bool
  public var isSynchronizableSet : Bool
}

extension InternetPasswordItemBuilder {
  public var dataString : String {
    get {
      return String(data: self.data, encoding: .utf8) ?? ""
    }
    set {
      self.data = newValue.data(using: .utf8) ?? .init()
    }
  }
  
  public var url : URL? {
    var components = URLComponents()
    components.scheme = self.protocol?.rawValue
    components.host = self.server
    components.path = self.path ?? ""
    components.port = self.port
    return components.url
  }
  
  public var descriptionText : String {
    get {
      return self.description ?? ""
    }
    set {
      self.description = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }
  }
  
  public var accessGroupText : String {
    get {
      return self.accessGroup ?? ""
    }
    set {
      self.accessGroup = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }
  }
  
  public var label : String? {
    return hasLabel ? labelValue : nil
  }
  
  public var type : Int? {
    return hasType ? typeValue : nil
  }
  
  public var isSynchronizable : Bool? {
    return isSynchronizableSet ? isSynchronizableValue : nil
  }
  
  public var isModified : Bool {
    guard let source else {
      return true
    }
    return [
      self.account != source.account,
      self.isSynchronizable != source.isSynchronizable,
      self.type != source.type,
      self.accessGroup != source.accessGroup,
      self.authenticationType != source.accessGroup,
      self.server != source.server,
      self.protocol != source.protocol,
      self.port != source.port,
      self.path != source.path
    ].first {!$0} ?? true
  }
  
  public func saved () -> InternetPasswordItemBuilder {
    return .init(
      source: .init(builder: self),
      account : self.account,
      data : self.data,
      accessGroup : self.accessGroup,
      createdAt : self.createdAt,
      modifiedAt : self.modifiedAt,
      description : self.description,
      type : self.type,
      label : self.label,
      server : self.server,
      protocol : self.protocol,
      authenticationType : self.authenticationType,
      port : self.port,
      path : self.path,
      isSynchronizable : self.isSynchronizable
    )
  }
}

extension InternetPasswordItemBuilder {
  init (item: InternetPasswordItem?) {
    guard let item = item else {
      self.init()
      return
    }
    
    self.init(
      source: item,
      account : item.account,
      data : item.data,
      accessGroup : item.accessGroup,
      createdAt : item.createdAt,
      modifiedAt : item.modifiedAt,
      description : item.description,
      type : item.type,
      label : item.label,
      server : item.server,
      protocol : item.protocol,
      authenticationType : item.authenticationType,
      port : item.port,
      path : item.path,
      isSynchronizable : item.isSynchronizable
    )
  }
}

protocol CredentialsRepository {
  func create(_ item: InternetPasswordItem) throws
  func update(_ item: InternetPasswordItem) throws
  func query(_ query: Query) throws -> [InternetPasswordItem]  
}

class InternetPasswordObject : ObservableObject {
  internal init( repository: CredentialsRepository, item: InternetPasswordItemBuilder, isNew: Bool) {
    self.item = item
    self.repository = repository
    self.isNew = isNew
    
    let savePublisher = saveTriggerSubject
      .map{self.item}
      .map(InternetPasswordItem.init)
      .tryMap { item in
        if self.isNew {
          try self.repository.create(item)
        } else {
          try self.repository.update(item)
        }
      }
      .share()
    
    let successPublisher = savePublisher
      .map(Optional<Void>.some)
      .replaceError(with: Optional<Void>.none)
      .compactMap{$0}
      .share()
    
    successPublisher
      .map{self.item.saved()}
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$item)
    
    saveCompletedCancellable = successPublisher
      .subscribe(self.saveCompletedSubject)
    
    savePublisher
      .map{Optional<Error>.none}
      .catch{Just(Optional.some($0))}
      .compactMap{$0 as? KeychainError}
      .receive(on: DispatchQueue.main)
      .print()
      .assign(to: &self.$lastError)
   
    clearErrorSubject
      .filter{$0 == self.lastError}
      .map{_ in Optional<KeychainError>.none}
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$lastError)
    
  }
  
  func save () {
    self.saveTriggerSubject.send()
  }
  
  func clearError (_ error: KeychainError) {
    self.clearErrorSubject.send(error)
  }
  
  
  @Published var lastError: KeychainError?
  @Published var item : InternetPasswordItemBuilder
  let saveTriggerSubject = PassthroughSubject<Void, Never>()
  let clearErrorSubject = PassthroughSubject<KeychainError, Never>()
  let saveCompletedSubject = PassthroughSubject<Void, Never>()
  let repository : CredentialsRepository
  let isNew : Bool
  var saveCompletedCancellable : AnyCancellable!
  
  var saveCompleted : AnyPublisher<Void, Never> {
    return self.saveCompletedSubject.eraseToAnyPublisher()
  }
}

extension InternetPasswordObject {
  convenience init(repository: CredentialsRepository, item: InternetPasswordItem? = nil) {
    self.init(repository: repository, item: .init(item: item), isNew: item == nil)
  }
}

struct InternetPasswordView: View {
  internal init(object: InternetPasswordObject) {
    self._object = .init(wrappedValue: object)
  }
  @Environment(\.dismiss) private var dismiss
  @State var shouldConfirmDismiss = false
  @State var isErrorAlertVisible = false
  @StateObject var object : InternetPasswordObject
  
  fileprivate func InternetPasswordFormContent() -> some View {
    Group{
      Section("Account") {
        TextField("account", text: $object.item.account)
      }
      
      Section("Data") {
        TextEditor(text: $object.item.dataString).frame(height: 80.0)
      }
      
      Section("Is Syncronizable") {
        Toggle("Is Set", isOn: $object.item.isSynchronizableSet)
        Toggle("Is Syncronizable", isOn: $object.item.isSynchronizableValue)
      }
      
      Section("Access Group") {
        TextEditor(text: $object.item.accessGroupText).frame(height: 60.0)
      }
      
      Section("Type") {
        Toggle("Set Type", isOn: $object.item.hasType)
        Stepper(value: $object.item.typeValue) {
          Text("\(object.item.typeValue)")
        }
      }
      
      Section("Label") {
        Toggle("Set Label", isOn: $object.item.hasLabel)
        TextField("label", text: $object.item.labelValue)
      }
      
      Section("URL"){
        Text(object.item.url?.description ?? "")
      }
      
      Section("Description") {
        TextEditor(text: $object.item.descriptionText).frame(height: 80.0)
      }
    }
  }
  
  var body: some View {
    Form{
      InternetPasswordFormContent()
    }
    .onReceive(self.object.$lastError, perform: { error in
      self.isErrorAlertVisible = error != nil
    })
    .onReceive(self.object.saveCompleted, perform: { _ in
      self.dismiss()
    })
    .alert(isPresented: self.$isErrorAlertVisible, error: self.object.lastError, actions: { error in
      Button("OK") {
        self.object.clearError(error)
      }
    }, message: { error in
      Text(error.localizedDescription)
    })
    .alert("Unsaved Changes", isPresented: self.$shouldConfirmDismiss, actions: {
      Button("Save and Go Back.") {
        self.object.save()
      }
      Button("Undo Changes and Go Back.") {
        dismiss()
      }
      
      Button("Cancel") {
        
      }
    }, message: {
      Text("You have unsaved changes.")
    })
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarLeading) {
        Button("Back") {
          guard self.object.item.isModified else {
            dismiss()
            return
          }
          Task { @MainActor in
            self.shouldConfirmDismiss = true
          }
        }
      }
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        Button("Save") {
          self.object.save()
        }
      }
    }.navigationBarBackButtonHidden(true)
  }
}

extension InternetPasswordView {
  init(repository: CredentialsRepository, item: InternetPasswordItem? = nil) {
    self.init(object: .init(repository: repository, item: item))
  }
}

struct InternetPasswordView_Previews: PreviewProvider {
  static var previews: some View {
    TabView{
      NavigationStack{
        InternetPasswordView(
          repository: PreviewRepository(),
          item: .previewCollection.first(where: { item in
            item.accessGroup != nil
          })
        )
      }.tabItem{
        Image(systemName: "key.fill")
        Text("Generic")
      }
    }
  }
}
