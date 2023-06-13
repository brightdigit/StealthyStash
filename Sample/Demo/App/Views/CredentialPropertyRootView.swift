import StealthyStash
import SwiftUI

struct CredentialPropertyRootView: View {
  internal init(repository: StealthyRepository, triggerSet: TriggerSet, internetPasswords: [AnyStealthyProperty] = [], isLoaded: Bool = false, query: Query, createNewItem: Bool = false) {
    _object = StateObject(wrappedValue: .init(repository: repository, triggerSet: triggerSet, internetPasswords: internetPasswords, isLoaded: isLoaded))
    _query = .init(initialValue: query)
    self.createNewItem = createNewItem
  }

  @StateObject var object: CredentialPropertyListObject
  @State var query: Query
  @State var createNewItem = false
  @State var isErrorAlertVisible = false

  var navigationTitle: String {
    switch query.type {
    case .generic:
      return "Generic Passwords"
    case .internet:
      return "Internet Passwords"
    }
  }

  var newNavigationTitle: String {
    switch query.type {
    case .generic:
      return "New Generic Passwords"
    case .internet:
      return "New Internet Passwords"
    }
  }

  var body: some View {
    NavigationStack {
      Form {
        Section {
          Button(role: .none) {} label: {
            if !(query is TypeQuery) {
              HStack {
                Text("").italic()
                Spacer()
                Image(systemName: "magnifyingglass")
              }
            } else {
              HStack {
                Text("Query")
                Spacer()
                Image(systemName: "magnifyingglass")
              }
            }
          }
        }
        Section {
          Group {
            if self.object.isLoaded {
              CredentialPropertyList(object: object).accessibilityIdentifier("propertyList")
            } else {
              ProgressView()
            }
          }
        } header: {
          HStack {
            Text("account")
            Spacer()
            Text("data")
          }
        }
      }
      .onReceive(self.object.$lastError, perform: { error in
        self.isErrorAlertVisible = error != nil
      })
      .alert(isPresented: self.$isErrorAlertVisible, error: self.object.lastError, actions: { _ in
        Button("OK") {}
      }, message: { error in
        Text(error.localizedDescription)
      })
      .navigationTitle(self.navigationTitle)
      .toolbar {
        Button {
          self.createNewItem = true
        } label: {
          Image(systemName: "plus")
        }
      }.navigationDestination(for: AnyStealthyProperty.self) { item in
        CredentialPropertyView(repository: self.object.repository, item: item).navigationTitle(item.account)
      }.navigationDestination(isPresented: self.$createNewItem) {
        CredentialPropertyView(repository: self.object.repository, type: self.query.type).navigationTitle(self.newNavigationTitle)
      }.onAppear {
        self.object.query(self.query)
      }
    }
  }
}

struct CredentialPropertyRootView_Previews: PreviewProvider {
  static var previews: some View {
    CredentialPropertyRootView(repository: PreviewRepository(
      items: AnyStealthyProperty.previewCollection
    ), triggerSet: .init(), internetPasswords: AnyStealthyProperty.previewCollection, query: TypeQuery(type: .internet))
  }
}
