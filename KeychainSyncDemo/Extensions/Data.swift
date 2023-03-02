//
//  CompositeSecret.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 3/2/23.
//

import Foundation

extension Data {
  func string (encoding: String.Encoding = .utf8) -> String? {
    return String(data: self, encoding: encoding)
  }
}
