//
//  ContentView.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/21/23.
//

import SwiftUI
import Combine
import FloxBxAuth
struct PreviewRepository : CredentialRepository {
  func addItem(_ item: CredentialItem) {
    
  }
  
  
}



protocol CredentialRepository {
  func addItem(_ item: CredentialItem) throws
}

struct CreditialItemBuilder {
  var itemClass : ItemClass = .generic
  var dataString : String = ""
  var account: String = ""
  var type : Int = 0
  var containsType : Bool = false
  var label : String = ""
  var containsLabel : Bool = false
}
struct CredentialItem {
  internal init(itemClass: ItemClass, data: Data, account: String, type: Int? = nil, label: String? = nil, isSynchronizable : Bool? = nil) {
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
  
  let itemClass : ItemClass
  let data : Data
  let account: String
  let type : Int?
  let label : String?
  let serviceName : String?
  let server : String?
  let accessGroup : String?
  let isSynchronizable : Bool?
}

extension CredentialItem {
  init (builder : CreditialItemBuilder) {
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

class AddItemObject : ObservableObject {
  internal init(repository: CredentialRepository, item: CreditialItemBuilder = CreditialItemBuilder(), lastError: KeychainError? = nil) {
    self.repository = repository
    self.item = item
    self.lastError = lastError
    
    let itemAddResult = self.triggerAddSubject
      .map { self.item  }
      .map(CredentialItem.init(builder:))
      .map { item in
        Result {
          try self.repository.addItem(item)
        }
      }.share()
    
    
    itemAddResult.compactMap{try? $0.get()}.map {
      CreditialItemBuilder()
    }.assign(to: &self.$item)
    
    itemAddResult.compactMap{ result -> KeychainError? in
      guard case .failure(let error as KeychainError) = result else {
        return nil
      }
      
      return error
    }.map{$0 as KeychainError?}
      .assign(to: &self.$lastError)
  }
  
  
  let repository : CredentialRepository
  
  @Published var item = CreditialItemBuilder()
  let triggerAddSubject = PassthroughSubject<Void, Never>()
  @Published var lastError : KeychainError?
  
  
  func addItem () {
    triggerAddSubject.send()
  }
}

enum ItemClass : Int, CaseIterable, CustomStringConvertible, Identifiable, Hashable {

  
 
  var id: Int {
    return self.rawValue
  }
  
  case generic
  case internet
  
  var description: String {
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


struct SheetErrorModel : Identifiable {
  let id : UUID
  let error: Error
}

struct ContentView: View {
  @StateObject var object : AddItemObject
  @State var shouldDisplayAlert : Bool = false
  
  init(repository : CredentialRepository,item: CreditialItemBuilder = CreditialItemBuilder(), lastError: KeychainError? = nil) {
    self._object = StateObject(wrappedValue: .init(repository: repository, item: item, lastError: lastError))
  }
    var body: some View {
      TabView{
        Form{
          Section{
            Picker("Type", selection: $object.item.itemClass) {
              ForEach(ItemClass.allCases) { type in
                Text(type.description).tag(type)
              }
            }
          }
          Section{
            TextField("Account", text: $object.item.account, prompt: Text("Account for Data"))
          }
          Section{
            #if os(watchOS)
            TextField("Data", text: $object.item.dataString, prompt: Text("Data"))
            
            #else
            TextEditor(text: $object.item.dataString)
            #endif
            
          }
          
          Section{
            
            Toggle("Use Label", isOn: $object.item.containsLabel)
            TextField("Label", text: $object.item.label).disabled(!self.object.item.containsLabel).opacity(self.object.item.containsLabel ? 1.0 : 0.8)
          }
          
          Section{
            Toggle("Use Type", isOn: $object.item.containsType)
            Group{
#if os(watchOS)
              Stepper( value: $object.item.type) {
                Text(self.object.item.type, format: .number)
              }
#else
              HStack{
                Stepper("Type", value: $object.item.type)
                TextField("Type Value", value:  $object.item.type, formatter: NumberFormatter())
                
              }
#endif
            }.disabled(!self.object.item.containsType).opacity(self.object.item.containsType ? 1.0 : 0.8)
          }
          Section{
              Button("Add") {
                self.object.addItem()
              }
            
            }
            Section{
              Button("Clear") {
                
              }
            }
          }
        .onReceive(self.object.$lastError, perform: { error in
          self.shouldDisplayAlert = error != nil
        })
        .alert(isPresented: self.$shouldDisplayAlert, error: self.object.lastError, actions: {
            Button("OK") {
              self.object.lastError = nil
            }
        })
        
        .tabItem {
          Image(systemName: "plus")
          Text("Add Item")
        }
        
        
          VStack {
            Image(systemName: "globe")
              .imageScale(.large)
              .foregroundColor(.accentColor)
            Text("Hello, world!")
          }
          .padding()
          .tabItem {
            Image(systemName: "magnifyingglass")
            Text("Query")
          }
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView(repository: PreviewRepository(), lastError: KeychainError.unexpectedPasswordData)
    }
}
