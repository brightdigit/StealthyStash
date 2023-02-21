import SwiftUI

struct InternetPasswordView: View {
  internal init(object: InternetPasswordObject) {
    self._object = .init(wrappedValue: object)
  }
  @Environment(\.dismiss) private var dismiss
  @State var shouldConfirmDismiss = false
  @State var isErrorAlertVisible = false
  @StateObject var object : InternetPasswordObject
  
  var body: some View {
    Form{
      InternetPasswordFormContentView(object: object)
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
