import Foundation
#if canImport(os)
  import os
#else
  import Logging
#endif

public protocol Loggable {
  static var logger: Logger {
    get
  }
}
