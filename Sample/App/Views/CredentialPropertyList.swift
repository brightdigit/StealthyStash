import StealthyStash
import SwiftUI

extension StealthyPropertyType {
  var sfSymbolName: String {
    switch self {
    case .internet:
      return "network"
    case .generic:
      return "key.fill"
    }
  }
}

struct CredentialPropertyList: View {
  internal init(object: CredentialPropertyListObject) {
    self.object = object
  }

  @ObservedObject var object: CredentialPropertyListObject
  var body: some View {
    #if os(iOS) || os(watchOS)
      List(object.credentialProperties) { item in
        NavigationLink(value: item) {
          HStack {
            #if !os(watchOS)
              Image(systemName: item.propertyType.sfSymbolName)
            #endif
            Text(item.account).accessibilityIdentifier("accountProperty")
            Spacer()
            Text(item.dataString).bold().accessibilityIdentifier("dataProperty")
          }.lineLimit(1)
        }
      }
    #else
      Table(object.properties) {
        TableColumn("") { _ in
          HStack {
            Button("Edit") {}
            Button("Delete") {}
          }
        }
        TableColumn("Account", value: \.account)
        TableColumn("Data", value: \.dataString)
      }
    #endif
  }
}

struct CredentialPropertyList_Previews: PreviewProvider {
  static var previews: some View {
    CredentialPropertyList(
      object: .init(repository: PreviewRepository(items: []),
                    triggerSet: .init(),
                    internetPasswords: AnyStealthyProperty.previewCollection,
                    isLoaded: true)
    )
  }
}
