//
//  CompositeSecretBuilder.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 3/22/23.
//

import Foundation

struct CompositeSecretBuilder {

  
  var userName = ""
  var password = ""
  var token = ""
}


extension CompositeSecretBuilder {
  init(secret : CompositeCredentials?) {
    self.init(
      userName: secret?.userName ?? "",
      password: secret?.password ?? "",
      token: secret?.token ?? ""
    )
  }
}


extension CompositeCredentials {
  init?(builder : CompositeSecretBuilder) {
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
