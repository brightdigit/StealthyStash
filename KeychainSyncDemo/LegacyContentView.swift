//
//  ContentView.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/21/23.
//

import SwiftUI
import Combine
import FloxBxAuth

@available(*, deprecated)
struct LegacyContentView: View {
  @StateObject var object : LegacyAddItemObject
  @State var shouldDisplayAlert : Bool = false
  
  init(repository : LegacyCredentialRepository,item: LegacyCreditialItemBuilder = LegacyCreditialItemBuilder(), lastError: KeychainError? = nil) {
    self._object = StateObject(wrappedValue: .init(repository: repository, item: item, lastError: lastError))
  }
    var body: some View {
      TabView{
        Form{
          Section{
            Picker("Type", selection: $object.item.itemClass) {
              ForEach(LegacyItemClass.allCases) { type in
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
      LegacyContentView(repository: LegacyPreviewRepository(), lastError: KeychainError.unexpectedPasswordData)
    }
}
