//
//  ContentView.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/24/23.
//

import SwiftUI

struct ContentView: View {
  let repository = KeychainRepository(defaultServiceName: "com.brightdigit.KeychainSyncDemo", defaultServerName: "com.brightdigit.KeychainSyncDemo", defaultAccessGroup: "MLT7M394S7.com.brightdigit.KeychainSyncDemo")
    var body: some View {
      TabView {
        CredentialPropertyRootView(repository: repository, query: TypeQuery(type: .internet)).tabItem{
          Image(systemName: "network")
          Text("Internet")
        }
        
          CredentialPropertyRootView(repository: repository, query: TypeQuery(type: .generic))
        .tabItem{
          Image(systemName: "key.fill")
          Text("Generic")
        }
        
        CompositeSecretView(repository: repository)
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
