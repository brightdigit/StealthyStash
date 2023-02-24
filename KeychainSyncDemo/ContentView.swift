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
        InternetPasswordRootView(object: .init(internetPasswords: InternetPasswordItem.previewCollection
          )).tabItem{
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
