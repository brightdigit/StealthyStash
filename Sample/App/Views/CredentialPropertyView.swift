import SwiftUI
import StealthyStash

struct CredentialPropertyView: View {
  internal init(object: CredentialPropertyObject) {
    self._object = .init(wrappedValue: object)
  }
  @Environment(\.dismiss) private var dismiss
  @State var shouldConfirmDismiss = false
  @State var isErrorAlertVisible = false
  @StateObject var object : CredentialPropertyObject
  
  var body: some View {
    Form{
      CredentialPropertyFormContentView(object: object)
    }
    .onReceive(self.object.$lastError, perform: { error in
      self.isErrorAlertVisible = error != nil
    })
    .onReceive(self.object.updateCompleted, perform: { _ in
      self.dismiss()
    })
    .alert(isPresented: self.$isErrorAlertVisible, error: self.object.lastError, actions: { error in
      Button("OK") {
        self.object.clearError(error)
      }
    }, message: { error in
      Text(error.localizedDescription)
    })
    .alert("Unsaved Changes", isPresented: self.$shouldConfirmDismiss, actions: {
      Button("Save and Go Back.") {
        self.object.save()
      }
      Button("Undo Changes and Go Back.") {
        dismiss()
      }
      
      Button("Cancel") {
        
      }
    }, message: {
      Text("You have unsaved changes.")
    })
    .toolbar {
      ToolbarItemGroup(placement: .cancellationAction) {
        Button("Back") {
          guard self.object.item.isModified else {
            dismiss()
            return
          }
          Task { @MainActor in
            self.shouldConfirmDismiss = true
          }
        }
      }
      ToolbarItemGroup(placement: .destructiveAction) {
        Button("Delete") {
          self.object.delete()
        }
      }
      ToolbarItemGroup(placement: .confirmationAction) {
        Button("Save") {
          self.object.save()
        }
      }
    }.navigationBarBackButtonHidden(true)
  }
}

extension CredentialPropertyView {
  init(repository: SecretsRepository, item: AnySecretProperty) {
    self.init(object: .init(repository: repository, item: item))
  }
  
  init(repository: SecretsRepository, type: SecretPropertyType) {
    self.init(object: .init(repository: repository, type: type))
  }
}

struct InternetPasswordView_Previews: PreviewProvider {
  static var previews: some View {
    TabView{
      NavigationStack{
        CredentialPropertyView(
          repository: PreviewRepository(items: []),
          item: AnySecretProperty.previewCollection.first(where: { item in
            item.accessGroup != nil
          })!
        )
      }.tabItem{
        Image(systemName: "key.fill")
        Text("Generic")
      }
    }
  }
}
