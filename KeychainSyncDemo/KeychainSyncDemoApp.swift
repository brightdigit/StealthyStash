//
//  KeychainSyncDemoApp.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/21/23.
//

import SwiftUI
import FloxBxAuth

@main
struct KeychainSyncDemoApp: App {
    var body: some Scene {
        WindowGroup {
          LegacyContentView(repository: KeychainRepository(defaultServiceName: "com.brightdigit.KeychainSyncDemo", defaultServerName: "com.brightdigit.KeychainSyncDemo", defaultAccessGroup: "MLT7M394S7.com.brightdigit.KeychainSyncDemo", defaultSynchronizable: true))
        }
    }
}
