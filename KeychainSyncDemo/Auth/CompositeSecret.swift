//
//  CompositeSecret.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 3/2/23.
//

import Foundation

struct CompositeSecret {
  internal init(username: String, password: String, token: String) {
    self.username = username
    self.password = password
    self.token = token
  }
  
  let username : String
  let password : String
  let token : String
  
  
}
