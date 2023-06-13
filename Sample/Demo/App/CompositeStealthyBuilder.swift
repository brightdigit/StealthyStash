import Foundation

struct CompositeStealthyBuilder {
  var userName = ""
  var password = ""
  var token = ""
}

extension CompositeStealthyBuilder {
  init(secret: CompositeCredentials?) {
    self.init(
      userName: secret?.userName ?? "",
      password: secret?.password ?? "",
      token: secret?.token ?? ""
    )
  }
}

extension CompositeCredentials {
  init?(builder: CompositeStealthyBuilder) {
    guard let userName = builder.userName.nilTrimmed() else {
      return nil
    }

    let password = builder.password.nilTrimmed() ?? ""

    let token = builder.token.nilTrimmed() ?? ""

    self.init(
      userName: userName,
      password: password,
      token: token
    )
  }
}
