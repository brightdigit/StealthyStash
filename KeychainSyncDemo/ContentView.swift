//
//  ContentView.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/21/23.
//

import SwiftUI

enum ItemType : Int, CaseIterable, CustomStringConvertible, Identifiable, Hashable {

  
 
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
}



struct ContentView: View {
    var body: some View {
      TabView{
        Form{
          Section{
            Picker("Type", selection: .constant(ItemType.generic)) {
              ForEach(ItemType.allCases) { type in
                Text(type.description)
              }
            }
          }
          Section{
            TextField("Account", text: .constant("account"), prompt: Text("Account for Data"))
          }
          Section{
            TextEditor(text: .constant("data"))
          }
          
          Section{
            Toggle("Use Label", isOn: .constant(true))
            TextField("Label", text: .constant("label"))
          }
          
          Section{
            Toggle("Use Type", isOn: .constant(true))
            HStack{
              Stepper("Type", value: .constant(2))
              TextField("Type Value", value: .constant(2), formatter: NumberFormatter())
              
            }
          }
          Section{
              Button("Add") {
                
              }
            
            }
            Section{
              Button("Clear") {
                
              }
            }
          }
        
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
        ContentView()
    }
}
