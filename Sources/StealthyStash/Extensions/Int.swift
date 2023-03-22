//
//  InternetPasswordRootView.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/24/23.
//

import SwiftUI
import Combine


extension Int {
  func trimZero () -> Int? {
    return self == 0 ? nil : self
  }
}
