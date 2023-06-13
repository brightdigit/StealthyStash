import Combine
import StealthyStash
import SwiftUI

struct CompositeStealthyView: View {
  internal init(object: CompositeStealthyObject) {
    _object = .init(wrappedValue: object)
  }

  internal init(repository: StealthyRepository, triggerSet: TriggerSet, secret: CompositeStealthyBuilder = .init()) {
    self.init(object: .init(repository: repository, triggerSet: triggerSet, secret: secret))
  }

  @StateObject var object: CompositeStealthyObject

  var body: some View {
    NavigationView {
      Group {
        if object.isLoaded {
          Form {
            Section("User Name") {
              TextField("User name", text: self.$object.secret.userName)
            }

            Section("Password") {
              TextField("Password", text: self.$object.secret.password)
            }

            Section("Token") {
              TextField("Token", text: self.$object.secret.token)
            }

            Section {
              Button("Save") {
                self.object.save()
              }

              Button("Reset", role: .destructive) {
                self.object.reset()
              }
            }

            if let lastError = object.lastError {
              Section("Error") {
                Text(lastError.localizedDescription)
              }
            }
          }
        } else {
          ProgressView()
        }
      }.onAppear {
        self.object.load()
      }.navigationTitle("Person Entry")
    }
  }
}

struct CompositeStealthyView_Previews: PreviewProvider {
  static var previews: some View {
    CompositeStealthyView(repository: PreviewRepository(items: []), triggerSet: .init(), secret: .init(userName: "username", password: "password", token: "token"))
  }
}
