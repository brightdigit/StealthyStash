import SwiftUI

struct InternetPasswordView: View {
  internal init(object: InternetPasswordObject) {
    self._object = .init(wrappedValue: object)
  }
  @Environment(\.dismiss) private var dismiss
  @State var shouldConfirmDismiss = false
  @State var isErrorAlertVisible = false
  @StateObject var object : InternetPasswordObject
  
  fileprivate func InternetPasswordFormContent() -> some View {
    Group{
      Section("Account") {
        TextField("account", text: $object.item.account)
      }
      
      Section("Data") {
        TextEditor(text: $object.item.dataString).frame(height: 80.0)
      }
      
      Section("Is Syncronizable") {
        Toggle("Is Set", isOn: $object.item.isSynchronizableSet)
        Toggle("Is Syncronizable", isOn: $object.item.isSynchronizableValue)
      }
      
      Section("Access Group") {
        TextEditor(text: $object.item.accessGroupText).frame(height: 60.0)
      }
      
      Section("Type") {
        Toggle("Set Type", isOn: $object.item.hasType)
        Stepper(value: $object.item.typeValue) {
          Text("\(object.item.typeValue)")
        }
      }
      
      Section("Label") {
        Toggle("Set Label", isOn: $object.item.hasLabel)
        TextField("label", text: $object.item.labelValue)
      }
      
      Section("URL"){
        Text(object.item.url?.description ?? "")
      }
      
      Section("Description") {
        TextEditor(text: $object.item.descriptionText).frame(height: 80.0)
      }
    }
  }
  
  var body: some View {
    Form{
      InternetPasswordFormContent()
    }
    .onReceive(self.object.$lastError, perform: { error in
      self.isErrorAlertVisible = error != nil
    })
    .onReceive(self.object.saveCompleted, perform: { _ in
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
      ToolbarItemGroup(placement: .navigationBarLeading) {
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
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        Button("Save") {
          self.object.save()
        }
      }
    }.navigationBarBackButtonHidden(true)
  }
}

extension InternetPasswordView {
  init(repository: CredentialsRepository, item: InternetPasswordItem? = nil) {
    self.init(object: .init(repository: repository, item: item))
  }
}

struct InternetPasswordView_Previews: PreviewProvider {
  static var previews: some View {
    TabView{
      NavigationStack{
        InternetPasswordView(
          repository: PreviewRepository(),
          item: .previewCollection.first(where: { item in
            item.accessGroup != nil
          })
        )
      }.tabItem{
        Image(systemName: "key.fill")
        Text("Generic")
      }
    }
  }
}
