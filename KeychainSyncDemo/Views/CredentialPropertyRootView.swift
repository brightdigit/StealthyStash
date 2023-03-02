import SwiftUI

struct CredentialPropertyRootView: View {
  internal init(repository: SecretsRepository, internetPasswords: [AnySecretProperty]? = nil, query: Query, createNewItem: Bool = false) {
    self._object = StateObject(wrappedValue: .init(repository: repository, internetPasswords: internetPasswords))
    self.query = query
    self.createNewItem = createNewItem
  }
  
  @StateObject var object : CredentialPropertyListObject
  @State var query : Query
  @State var createNewItem = false
  @State var isErrorAlertVisible = false
  
  var navigationTitle : String {
    switch query.type {
    case .generic:
      return "Generic Passwords"
    case .internet:
      return "Internet Passwords"
    }
  }
  
  var newNavigationTitle : String {
    switch query.type {
    case .generic:
      return "New Generic Passwords"
    case .internet:
      return "New Internet Passwords"
    }
  }
  
  var body: some View {
      NavigationStack {
        Form{
          Section{
            Button(role: .none) {
              
            } label: {
              if let query {
                HStack{
                  Text("").italic()
                  Spacer()
                  Image(systemName: "magnifyingglass")
                }
              } else {
                HStack{
                  Text("Query")
                  Spacer()
                  Image(systemName: "magnifyingglass")
                }
              }
              
            }

          }
          Section{
            Group{
              if let internetPasswords = self.object.credentialProperties {
                CredentialPropertyList(properties: internetPasswords)
              } else {
                ProgressView()
              }
            }
            
          } header: {
            HStack{
              Text("account")
              Spacer()
              Text("data")
            }
          }
        }
        .onReceive(self.object.$lastError, perform: { error in
          self.isErrorAlertVisible = error != nil
        })
        .alert(isPresented: self.$isErrorAlertVisible, error: self.object.lastError, actions: { error in
          Button("OK") {
            
          }
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
            
          }.navigationDestination(for: AnySecretProperty.self) { item in
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
        items: AnySecretProperty.previewCollection
      ), internetPasswords: AnySecretProperty.previewCollection, query: .init(type: .internet))
    }
}
