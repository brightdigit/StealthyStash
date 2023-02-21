import Combine

class PreviewInternetPasswordObject : ObservableObject {
  let internetPasswords : [InternetPasswordItem]
  
  init(internetPasswords: [InternetPasswordItem]) {
    self.internetPasswords = internetPasswords
  }
}
