//
//  ContentView.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/24/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
      TabView {
        InternetPasswordRootView(repository: KeychainRepository(defaultServiceName: "com.brightdigit.KeychainSyncDemo", defaultServerName: "com.brightdigit.KeychainSyncDemo", defaultAccessGroup: "MLT7M394S7.com.brightdigit.KeychainSyncDemo")).tabItem{
          Image(systemName: "network")
          Text("Internet")
        }
        
        NavigationView {
          
        }.tabItem{
          Image(systemName: "key.fill")
          Text("Generic")
        }
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
