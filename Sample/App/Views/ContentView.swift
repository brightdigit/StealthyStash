import StealthyStash
import SwiftUI

struct ContentView: View {
  let triggerSet = TriggerSet()
  let repository = KeychainRepository(defaultServiceName: "com.brightdigit.KeychainSyncDemo", defaultServerName: "com.brightdigit.KeychainSyncDemo", defaultAccessGroup: "MLT7M394S7.com.brightdigit.KeychainSyncDemo")
  var body: some View {
    TabView {
      CredentialPropertyRootView(repository: repository, triggerSet: self.triggerSet, query: TypeQuery(type: .internet)).tabItem {
        Image(systemName: "network")
        Text("Internet")
      }

      CredentialPropertyRootView(repository: repository, triggerSet: self.triggerSet, query: TypeQuery(type: .generic))
        .tabItem {
          Image(systemName: "key.fill")
          Text("Generic")
        }

      CompositeStealthyView(repository: repository, triggerSet: self.triggerSet)
        .tabItem {
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
