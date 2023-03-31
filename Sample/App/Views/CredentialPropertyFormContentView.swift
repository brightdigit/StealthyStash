import StealthyStash
import SwiftUI

struct CredentialPropertyFormContentView: View {
  @ObservedObject var object: CredentialPropertyObject
  var body: some View {
    Section("Account") {
      TextField("account", text: $object.item.account)
    }

    Section("Data") {
      #if os(watchOS)
        TextField("data", text: $object.item.dataString)
      #else
        TextEditor(text: $object.item.dataString).frame(height: 80.0).accessibilityIdentifier("data")
      #endif
    }

    Section("Is Syncronizable") {
      Toggle("Is Set", isOn: $object.item.isSynchronizableSet)
      Toggle("Is Syncronizable", isOn: $object.item.isSynchronizableValue)
    }

    Section("Access Group") {
      #if os(watchOS)
        TextField("access group", text: $object.item.accessGroupText)
      #else
        TextEditor(text: $object.item.accessGroupText).frame(height: 60.0)
      #endif
    }

    Section("Type") {
      Toggle("Set Type", isOn: $object.item.hasType)
      Stepper(value: $object.item.typeValue) {
        Text("\(object.item.typeValue)")
      }.accessibilityIdentifier("setTypeStepper")
    }

    Section("Label") {
      Toggle("Set Label", isOn: $object.item.hasLabel)
      TextField("label", text: $object.item.labelValue)
    }

    switch self.object.item.secClass {
    case .internet:
      Section("URL") {
        Text(object.item.url?.description ?? "")
      }

    case .generic:
      Section("Service") {
        Text(object.item.service ?? "")
      }
    }

    Section("Description") {
      #if os(watchOS)
        TextField("description", text: $object.item.descriptionText)
      #else
        TextEditor(text: $object.item.descriptionText).frame(height: 80.0)
      #endif
    }
  }
}

struct CredentialPropertyFormContentView_Previews: PreviewProvider {
  static var previews: some View {
    Form {
      CredentialPropertyFormContentView(object: CredentialPropertyObject(repository: PreviewRepository(items: AnyStealthyProperty.previewCollection), item: AnyStealthyProperty.previewCollection.randomElement()!))
    }
  }
}
