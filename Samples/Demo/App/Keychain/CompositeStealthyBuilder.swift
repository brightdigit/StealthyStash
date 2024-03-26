import Foundation

struct CompositeStealthyBuilder {
  var account = ""
  var password = ""
  var token = ""
}

extension CompositeStealthyBuilder {
  init(secret: CompositeCredentials?) {
    self.init(
      account: secret?.account ?? "",
      password: secret?.password ?? "",
      token: secret?.token ?? ""
    )
  }
}

extension CompositeCredentials {
  init?(builder: CompositeStealthyBuilder) {
    guard let account = builder.account.nilTrimmed() else {
      return nil
    }

    let password = builder.password.nilTrimmed() ?? ""

    let token = builder.token.nilTrimmed() ?? ""

    self.init(
      account: account,
      password: password,
      token: token
    )
  }
}
