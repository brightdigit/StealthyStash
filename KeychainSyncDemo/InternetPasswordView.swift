//
//  InternetPasswordView.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/24/23.
//

import SwiftUI
import Combine

struct PreviewRepository : CredentialsRepository {
  func create(_ item: InternetPasswordItem) throws {
    
  }
  
  func update(_ item: InternetPasswordItem) throws {
    
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
    components.scheme = self.protocol
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
}

class InternetPasswordObject : ObservableObject {
  internal init( repository: CredentialsRepository, item: InternetPasswordItemBuilder, isNew: Bool) {
    self.item = item
    self.repository = repository
    self.isNew = isNew
    
    let createError = createTriggerSubject
      .map{self.item}
      .map(InternetPasswordItem.init)
      .tryMap(self.repository.create(_:))
      .map{Optional<Error>.none}
      .catch{Just(Optional.some($0))}
      
    
    let updateError = updateTriggerSubject
      .map{self.item}
      .map(InternetPasswordItem.init)
      .tryMap(self.repository.update)
      .map{Optional<Error>.none}
      .catch{Just(Optional.some($0))}
    
    Publishers.Merge(createError, updateError)
      .compactMap{$0}
      .assign(to: &self.$lastError)
  }
  
  
  @Published var lastError: Error?
  @Published var item : InternetPasswordItemBuilder
  let createTriggerSubject = PassthroughSubject<Void, Never>()
  let updateTriggerSubject = PassthroughSubject<Void, Never>()
  let repository : CredentialsRepository
  let isNew : Bool
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
    .alert("Unsaved Changes", isPresented: self.$shouldConfirmDismiss, actions: {
      Button("Save and Go Back.") {
        
      }
      Button("Undo Changes and Go Back.") {
        
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
        }
      }
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        Button("Save") {
          
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
