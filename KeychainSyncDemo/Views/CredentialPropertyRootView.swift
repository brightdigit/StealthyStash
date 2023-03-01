import SwiftUI

struct CredentialPropertyRootView: View {
  internal init(repository: CredentialsRepository, internetPasswords: [AnyCredentialProperty]? = nil, query: Query, createNewItem: Bool = false) {
    self._object = StateObject(wrappedValue: .init(repository: repository, internetPasswords: internetPasswords))
    self.query = query
    self.createNewItem = createNewItem
  }
  
  @StateObject var object : CredentialPropertyListObject
  @State var query : Query
  @State var createNewItem = false
  @State var isErrorAlertVisible = false
  
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
              if let internetPasswords = self.object.internetPasswords {
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
        .navigationTitle("Internet Passwords")
          .toolbar {
            Button {
              self.createNewItem = true
            } label: {
              Image(systemName: "plus")
            }
            
          }.navigationDestination(for: AnyCredentialProperty.self) { item in
            CredentialPropertyView(repository: self.object.repository, item: item).navigationTitle(item.account)
          }.navigationDestination(isPresented: self.$createNewItem) {
            CredentialPropertyView(repository: self.object.repository, type: .internet)
          }.onAppear {
            self.object.query(self.query)
          }
      }
    }
}

struct CredentialPropertyRootView_Previews: PreviewProvider {
    static var previews: some View {
      CredentialPropertyRootView(repository: PreviewRepository(
        items: InternetPasswordItem.previewCollection.map({
          $0.eraseToAnyProperty()
        })
      ), internetPasswords: InternetPasswordItem.previewCollection.map({
        $0.eraseToAnyProperty()
      }), query: .init(type: .internet))
    }
}
