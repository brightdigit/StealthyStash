import Foundation
#if canImport(os)
  import os
#else
  import Logging
#endif

extension Logger {
  // swiftlint:disable:next force_unwrapping
  private static let subsystem: String = Bundle.main.bundleIdentifier!

  internal init<LoggerCategory: RawRepresentable>(category: LoggerCategory)
    where LoggerCategory.RawValue == String {
    #if canImport(os)
      self.init(subsystem: Self.subsystem, category: category.rawValue)
    #else
      self.init(label: Self.subsystem)
      self[metadataKey: "category"] = "\(category)"
    #endif
  }
}
