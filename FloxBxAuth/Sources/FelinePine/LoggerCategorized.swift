import Foundation
#if canImport(os)
  import os
#else
  import Logging
#endif

public protocol LoggerCategorized: Loggable {
  associatedtype LoggersType: Loggers
  static var loggingCategory: LoggersType.LoggerCategory {
    get
  }
}

extension LoggerCategorized {
  public static var logger: Logger {
    LoggersType.forCategory(loggingCategory)
  }
}
