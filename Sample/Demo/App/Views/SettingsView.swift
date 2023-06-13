import StealthyStash
import SwiftUI

struct SettingsView: View {
  let repository: StealthyRepository
  @State var shouldDisplayConfirmationAlert = false
  @State var shouldDisplayClearAllCompleted = false
  @State var keychainError: KeychainError?

  var body: some View {
    NavigationView {
      Form {
        Section {
          Button("Erase All Keychain Items") {
            Task { @MainActor in
              self.shouldDisplayConfirmationAlert = true
            }
          }
        }
      }
      .alert("All Keychain Items Deleted", isPresented: self.$shouldDisplayClearAllCompleted, actions: {
        Button("Ok") {}
      })
      .alert("Are you sure you want to delete all keychain items?", isPresented: self.$shouldDisplayConfirmationAlert, actions: {
        Button("No", role: .cancel) {}
        Button("Yes", role: .destructive) {
          do {
            try self.repository.clearAll()
          } catch let error as KeychainError {
            Task { @MainActor in
              self.keychainError = error
            }
          } catch {
            assertionFailure("unknown error clearing keychain: \(error.localizedDescription)")
          }
          Task { @MainActor in
            self.shouldDisplayClearAllCompleted = true
          }
        }
      })
      .navigationTitle("Settings")
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    TabView {
      VStack {}.tabItem {
        Image(systemName: "network")
        Text("Internet")
      }

      VStack {}.tabItem {
        Image(systemName: "key.fill")
        Text("Generic")
      }

      VStack {}.tabItem {
        Image(systemName: "person.badge.key.fill")
        Text("Person")
      }

      SettingsView(repository: PreviewRepository(items: [])).tabItem {
        Image(systemName: "gear")
        Text("Settings")
      }
    }
  }
}
