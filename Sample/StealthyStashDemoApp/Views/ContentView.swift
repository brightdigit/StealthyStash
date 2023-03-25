//
//  ContentView.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/24/23.
//

import SwiftUI
import StealthyStash

struct ContentView: View {
  let triggerSet = TriggerSet()
  let repository = KeychainRepository(defaultServiceName: "com.BrightDigit.StealthyStashDemoApp", defaultServerName: "com.BrightDigit.StealthyStashDemoApp", defaultAccessGroup: "MLT7M394S7.com.BrightDigit.StealthyStashDemoApp")
    var body: some View {
      TabView {
        CredentialPropertyRootView(repository: repository, triggerSet: self.triggerSet, query: TypeQuery(type: .internet)).tabItem{
          Image(systemName: "network")
          Text("Internet")
        }
        
          CredentialPropertyRootView(repository: repository, triggerSet: self.triggerSet, query: TypeQuery(type: .generic))
        .tabItem{
          Image(systemName: "key.fill")
          Text("Generic")
        }
        
        CompositeSecretView(repository: repository, triggerSet: self.triggerSet)
          .tabItem{
            Image(systemName: "person.badge.key.fill")
            Text("Person")
          }
        
        SettingsView(repository: repository).tabItem {
          Image(systemName: "gear")
          Text("Settings")
        }
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
