//
//  InternetPasswordView.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/24/23.
//


extension String {
  public func nilTrimmed ()  -> String? {
    let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed.isEmpty ? nil : trimmed
  }
}
